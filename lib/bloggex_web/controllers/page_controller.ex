defmodule BloggexWeb.PageController do
  use BloggexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
