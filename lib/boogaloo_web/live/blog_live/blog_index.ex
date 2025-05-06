defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs
  import BoogalooWeb.Components, only: [button: 1]

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

    <div>
      <div class="flex gap-x-3" data-hs-pin-input="">
        <input
          type="text"
          class="block size-9.5 text-center border-gray-200 rounded-md sm:text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none bg-gray-200"
          data-hs-pin-input-item=""
          autofocus=""
        />
        <input
          type="text"
          class="block size-9.5 text-center border-gray-200 rounded-md sm:text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none bg-gray-200"
          data-hs-pin-input-item=""
        />
        <input
          type="text"
          class="block size-9.5 text-center border-gray-200 rounded-md sm:text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none bg-gray-200"
          data-hs-pin-input-item=""
        />
        <input
          type="text"
          class="block size-9.5 text-center border-gray-200 rounded-md sm:text-sm focus:border-blue-500 focus:ring-blue-500 disabled:opacity-50 disabled:pointer-events-none bg-gray-200"
          data-hs-pin-input-item=""
        />
      </div>
    </div>

    <button
      type="button"
      class="py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 focus:outline-hidden focus:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none"
      aria-haspopup="dialog"
      aria-expanded="false"
      aria-controls="hs-basic-modal"
      data-hs-overlay="#hs-basic-modal"
    >
      Open modal
    </button>

    <button class="bg-gray-200 p-4" phx-click={BoogalooWeb.Components.open_modal("#example-modal")}>
      Open modal
    </button>

    <BoogalooWeb.Components.modal id="example-modal">
      test
      <:actions>
        <button>foo de faffa</button>
      </:actions>
    </BoogalooWeb.Components.modal>

    <BoogalooWeb.Components.modal id="another-example-modal">
      in the second example modal
      <:actions>
        <button>foo de faffa</button>
      </:actions>
    </BoogalooWeb.Components.modal>

    <button phx-click="toggle-shown" class="px-4 py-2 border-2 border-teal-200 bg-teal-100 rounded-lg">
      toggle
    </button>

    <.button>test</.button>
    <.button style={:outline}>test</.button>
    <.button style={:ghost}>test</.button>
    <.button style={:soft}>test</.button>
    <.button style={:white}>test</.button>
    <.button style={:link}>test</.button>

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
