defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs

  @impl true
  def mount(_params, _session, socket) do
    blogs = Blogs.list_blogs!(load: :user)

    socket =
      socket
      |> assign(:blogs, blogs)

    {:ok, socket}
  end

  @impl true
  def handle_event("rating:rate", %{"score" => score, "rateable-id" => blog_id}, socket) do
    Blogs.get_blog!(blog_id) |> Blogs.update_rating!(score)
    blogs = Blogs.list_blogs!(load: :user)
    {:noreply, assign(socket, :blogs, blogs)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Blogs</h1>

    <BoogalooWeb.Components.table id="blogs" rows={@blogs} striped?={true}>
      <:col :let={blog} label="Title"><.link patch={~p"/blogs/#{blog}"}>{blog.title}</.link></:col>
      <:col :let={blog} label="Author">{blog.user.email}</:col>
      <:col :let={blog} label="Published At">{blog.published_at}</:col>
      <:col :let={blog}>
        <BoogalooWeb.Components.rating
          current_rating={blog.rating}
          min={1}
          max={5}
          rateable_id={blog.id}
        />
      </:col>
    </BoogalooWeb.Components.table>
    """
  end
end
