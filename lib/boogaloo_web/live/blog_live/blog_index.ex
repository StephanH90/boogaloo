defmodule BoogalooWeb.BlogLive.BlogIndex do
  use BoogalooWeb, :live_view
  alias Boogaloo.Blogs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, blogs} = Blogs.list_blogs(load: :user)
    {:ok, assign(socket, blogs: blogs)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Blogs</h1>

    <div id="dropdown-test" class="hs-dropdown relative inline-flex">
      <button
        id="hs-dropdown-default"
        type="button"
        class="hs-dropdown-toggle py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 bg-white text-gray-800 shadow-2xs hover:bg-gray-50 focus:outline-hidden focus:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none"
        aria-haspopup="menu"
        aria-expanded="false"
        aria-label="Dropdown"
      >
        Actions
        <svg
          class="hs-dropdown-open:rotate-180 size-4"
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
          <path d="m6 9 6 6 6-6" />
        </svg>
      </button>

      <div
        class="z-10 hs-dropdown-menu transition-[opacity,margin] duration hs-dropdown-open:opacity-100 hidden min-w-60 bg-white shadow-md rounded-lg mt-2 after:h-4 after:absolute after:-bottom-4 after:start-0 after:w-full before:h-4 before:absolute before:-top-4 before:start-0 before:w-full"
        role="menu"
        aria-orientation="vertical"
        aria-labelledby="hs-dropdown-default"
      >
        <div class="p-1 space-y-0.5">
          <a
            class="flex items-center gap-x-3.5 py-2 px-3 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100"
            href="#"
          >
            Newsletter
          </a>
          <a
            class="flex items-center gap-x-3.5 py-2 px-3 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100"
            href="#"
          >
            Purchases
          </a>
          <a
            class="flex items-center gap-x-3.5 py-2 px-3 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100"
            href="#"
          >
            Downloads
          </a>
          <a
            class="flex items-center gap-x-3.5 py-2 px-3 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100"
            href="#"
          >
            Team Account
          </a>
        </div>
      </div>
    </div>
    <.table id="blogs" rows={@blogs}>
      <:col :let={blog} label="Title">{blog.title}</:col>
      <:col :let={blog} label="Author">{blog.user.email}</:col>
      <:col :let={blog} label="Published At">{blog.published_at}</:col>
    </.table>
    """
  end
end
