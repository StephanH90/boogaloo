defmodule Boogaloo.Blogs.Blog do
  @moduledoc """
  Ash resource representing a blog post, with title, body, and publication timestamp.
  """
  use Ash.Resource,
    data_layer: AshSqlite.DataLayer,
    domain: Boogaloo.Blogs

  alias Boogaloo.Accounts.User

  # SQLite configuration
  sqlite do
    table "blogs"
    repo Boogaloo.Repo
  end

  # Attributes
  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :body, :string, allow_nil?: false
    attribute :published_at, :utc_datetime
    attribute :user_id, :uuid, allow_nil?: false
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  # Actions
  actions do
    defaults [:read]
  end

  relationships do
    belongs_to :user, User
  end
end
