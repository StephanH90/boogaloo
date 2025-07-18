defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs
  alias ExUikit.Components
  import BoogalooWeb.Components, only: [button: 1]
  @impl true
  def mount(_params, _session, socket) do
    blogs = Blogs.list_blogs!(load: [:user, :truncated_body])

    socket =
      socket
      |> assign(:blogs, blogs)
      |> assign(:shown, false)
      |> assign(:foo, "not clicked")
      |> BoogalooWeb.Components.Live.Foo.init()

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
  def handle_event("direct-mutation", _unsigned_params, socket) do
    {:noreply, assign(socket, :foo, "clicked direct mutation")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <a href={~p"/embedded-ember"}>
    <Components.button style="primary" class="uk-margin-bottom uk-margin-top">Go to the ember app</Components.button>
    </a>
    <Components.grid  class="uk-child-width-expand@s">
    <Components.card>
      <:header>foo</:header>
      <:body>this is the body</:body>
      <:footer>this is the footer</:footer>
    </Components.card>


    <Components.card>
      <:body>
        <Components.button_group>
          <Components.button style="primary">Foo</Components.button>
          <Components.button style="secondary">Bar</Components.button>
        </Components.button_group>

      </:body>
    </Components.card>



    <Components.card>
      <:body>

      <div class="uk-inline">
    <button class="uk-button uk-button-default" type="button">Click</button>
    <div id="dropdown" uk-dropdown="mode: click">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</div>
    </div>

          </:body>
    </Components.card>

    </Components.grid>

    """
  end

  defp blog_card(assigns) do
    ~H"""
    <div class="flex flex-col bg-white border border-gray-200 shadow-2xs rounded-xl p-4 md:p-5 dark:bg-neutral-900 dark:border-neutral-700 dark:shadow-neutral-700/70">
      <h3 class="text-lg font-bold text-gray-800 dark:text-white">
        {@blog.title}
      </h3>
      <p class="mt-2 text-gray-500 dark:text-neutral-400">
        {@blog.truncated_body}
      </p>
      <.link
        class="mt-3 inline-flex items-center gap-x-1 text-sm font-semibold rounded-lg border border-transparent text-blue-600 decoration-2 hover:text-blue-700 hover:underline focus:underline focus:outline-hidden focus:text-blue-700 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-500 dark:hover:text-blue-600 dark:focus:text-blue-600"
        patch={~p"/blogs/#{@blog}"}
      >
        Show blog
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
          <path d="m9 18 6-6-6-6"></path>
        </svg>
      </.link>
    </div>
    """
  end
end
