defmodule BloggexWeb.Router do
  use BloggexWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :browser_auth do
    plug(BloggexWeb.Guardian.AuthPipeline)
    plug(BloggexWeb.Plug.CurrentUser)
  end

  pipeline :browser_ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(BloggexWeb.Plug.CurrentUser)
  end

  pipeline :admin_layout do
    plug(:put_layout, {BloggexWeb.Admin.LayoutView, :admin})
  end

  scope "/", BloggexWeb do
    # Admin scope
    scope "/admin", Admin, as: :admin do
      pipe_through([
        :browser,
        :browser_auth,
        :browser_ensure_auth,
        :admin_layout
      ])

      resources("/", DashboardController, only: [:index])
      resources("/users", UserController, except: [:show])
    end

    # Application unauthenticated scope
    scope "/" do
      pipe_through([:browser, :browser_auth])

      resources("/session", SessionController, only: [:new, :create])

      # Log out resource
      get("/logout", SessionController, :delete)

      resources("/", PageController)
    end
  end
end
