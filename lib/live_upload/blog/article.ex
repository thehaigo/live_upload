defmodule LiveUpload.Blog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :eyecatch, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :eyecatch])
    |> validate_required([:title, :body, :eyecatch])
  end
end
