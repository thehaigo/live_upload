defmodule LiveUploadWeb.ArticleLive.FormComponent do
  use LiveUploadWeb, :live_component

  alias LiveUpload.Blog

  @impl true
  def update(%{article: article} = assigns, socket) do
    changeset = Blog.change_article(article)

    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:eyecatch, accept: :any)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"article" => article_params}, socket) do
    changeset =
      socket.assigns.article
      |> Blog.change_article(article_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"article" => article_params}, socket) do
    article_params =
      case Enum.empty?(socket.assigns.uploads.eyecatch.entries) do
        true ->
          validate_required(article_params)

        false ->
          {:ok, uploaded_file_path} = consume_uploaded(socket)
          Map.put(article_params, "eyecatch", uploaded_file_path)
      end

    save_article(socket, socket.assigns.action, article_params)
  end

  def validate_required(params) do
    case params["eyecatch"] == "placeholder" do
      true -> Map.put(params, "eyecatch", nil)
      false -> params
    end
  end

  def consume_uploaded(socket) do
    image =
      consume_uploaded_entries(socket, :eyecatch, fn %{path: path}, entry ->
        upload_local(path, entry)
      end)
      |> List.first()

    {:ok, image}
  end

  def upload_local(path, entry) do
    dest = Path.join([:code.priv_dir(:live_upload), "uploads", generate_filemae(entry)])
    File.cp!(path, dest)
    "/uploads/#{Path.basename(dest)}"
  end

  def generate_filemae(entry) do
    extension = MIME.extensions(entry.client_type) |> List.first()
    entry.uuid <> ".#{extension}"
  end

  defp save_article(socket, :edit, article_params) do
    case Blog.update_article(socket.assigns.article, article_params) do
      {:ok, _article} ->
        {:noreply,
         socket
         |> put_flash(:info, "Article updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_article(socket, :new, article_params) do
    case Blog.create_article(article_params) do
      {:ok, _article} ->
        {:noreply,
         socket
         |> put_flash(:info, "Article created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
