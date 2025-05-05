defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs

  @impl true
  def mount(_params, _session, socket) do
    blogs = Blogs.list_blogs!(load: :user)

    socket =
      socket
      |> assign(:blogs, blogs)
      |> assign(:shown, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("rating:rate", %{"score" => score, "rateable-id" => blog_id}, socket) do
    Blogs.get_blog!(blog_id) |> Blogs.update_rating!(score)
    blogs = Blogs.list_blogs!(load: :user)
    {:noreply, assign(socket, :blogs, blogs)}
  end

  @impl true
  def handle_event("toggle-shown", _unsigned_params, socket) do
    {:noreply, assign(socket, :shown, !socket.assigns.shown)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Blogs</h1>

    <button
      type="button"
      class="py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 focus:outline-hidden focus:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none"
      aria-haspopup="dialog"
      aria-expanded="false"
      aria-controls="hs-offcanvas-example"
      data-hs-overlay="#hs-offcanvas-example"
    >
      Open offcanvas
    </button>

    <div
      id="hs-offcanvas-example"
      class="hs-overlay hs-overlay-open:translate-x-0 hidden -translate-x-full fixed top-0 start-0 transition-all duration-300 transform h-full max-w-xs w-full z-80 bg-white border-e border-gray-200"
      role="dialog"
      tabindex="-1"
      aria-labelledby="hs-offcanvas-example-label"
    >
      <div class="flex justify-between items-center py-3 px-4 border-b border-gray-200">
        <h3 id="hs-offcanvas-example-label" class="font-bold text-gray-800">
          Offcanvas title
        </h3>
        <button
          type="button"
          class="size-8 inline-flex justify-center items-center gap-x-2 rounded-full border border-transparent bg-gray-100 text-gray-800 hover:bg-gray-200 focus:outline-hidden focus:bg-gray-200 disabled:opacity-50 disabled:pointer-events-none"
          aria-label="Close"
          data-hs-overlay="#hs-offcanvas-example"
        >
          <span class="sr-only">Close</span>
          <svg
            class="shrink-0 size-4"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M18 6 6 18"></path>
            <path d="m6 6 12 12"></path>
          </svg>
        </button>
      </div>
      <div class="p-4">
        <p class="text-gray-800">
          Some text as placeholder. In real life you can have the elements you have chosen. Like, text, images, lists, etc.
        </p>
      </div>
    </div>

    <button phx-click="toggle-shown" class="px-4 py-2 border-2 border-teal-200 bg-teal-100 rounded-lg">
      toggle
    </button>

    <BoogalooWeb.Components.dropdown :if={@shown} label="foo" id="test-dropdown">
      <:option>foo</:option>
      <:option><.link patch={~p"/blogs"}>Blogs</.link></:option>
    </BoogalooWeb.Components.dropdown>

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
