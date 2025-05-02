defmodule Boogaloo.Blogs do
  @moduledoc """
  The Blogs domain context, providing access to blog resources via Ash.
  """
  use Ash.Domain, otp_app: :boogaloo

  resources do
    resource Boogaloo.Blogs.Blog do
      define :list_blogs, action: :read
      define :get_blog!, action: :read, get_by: [:id]
    end
  end
end
