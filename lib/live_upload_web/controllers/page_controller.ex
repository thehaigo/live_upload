defmodule LiveUploadWeb.PageController do
  use LiveUploadWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
