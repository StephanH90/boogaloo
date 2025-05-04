defmodule BoogalooWeb.BlogLive.Show do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    blog = Blogs.get_blog!(id) |> dbg()

    {:noreply,
     socket
     |> assign(:page_title, "Show Blog")
     |> assign(:blog, blog)}
  end
end
