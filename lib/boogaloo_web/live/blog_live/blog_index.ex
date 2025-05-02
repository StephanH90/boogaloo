defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs

  @impl true
  def mount(_params, _session, socket) do
    blogs = Blogs.list_blogs(load: [:user])
    {:ok, assign(socket, blogs: blogs)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Blogs</h1>
    <.table id="blogs" rows={@blogs}>
      <:col :let={blog} label="Title">{blog.title}</:col>
      <:col :let={blog} label="Author">{blog.user && blog.user.email || "Unknown"}</:col>
      <:col :let={blog} label="Published At">{blog.published_at}</:col>
    </.table>
    """
  end
end
