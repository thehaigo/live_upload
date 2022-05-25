defmodule LiveUploadWeb.PageController do
  use LiveUploadWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.article_index_path(LiveUploadWeb.Endpoint, :index))
  end
end
