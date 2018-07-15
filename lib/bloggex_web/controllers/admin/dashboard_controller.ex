defmodule BloggexWeb.Admin.DashboardController do
  use BloggexWeb, :controller

  alias Bloggex.Accounts.User
  alias Bloggex.Repo

  def index(conn, _params) do
    with users <- Repo.aggregate(User, :count, :id) do
      render(conn, "index.html", users: users)
    end
  end
end
