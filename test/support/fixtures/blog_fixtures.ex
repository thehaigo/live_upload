defmodule LiveUpload.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveUpload.Blog` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        eyecatch: "some eyecatch",
        title: "some title"
      })
      |> LiveUpload.Blog.create_article()

    article
  end
end
