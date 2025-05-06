defmodule BoogalooWeb.Components do
  use BoogalooWeb, :html

  # Rating components
  def rating(assigns) do
    ~H"""
    <div class="flex items-center">
      <button
        :for={rating <- @min..@max}
        type="button"
        class={[
          "size-5 inline-flex justify-center items-center text-2xl rounded-full disabled:opacity-50 disabled:pointer-events-none",
          @current_rating >= rating && "text-yellow-400 dark:text-yellow-500"
        ]}
        phx-click="rating:rate"
        phx-value-score={rating}
        phx-value-rateable-id={@rateable_id}
      >
        <svg
          class="shrink-0 size-5"
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          fill="currentColor"
          viewBox="0 0 16 16"
        >
          <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z">
          </path>
        </svg>
      </button>
    </div>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  attr :striped?, :boolean, default: false, doc: "if the table should be striped"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="flex flex-col">
      <div class="-m-1.5 overflow-x-auto">
        <div class="p-1.5 min-w-full inline-block align-middle">
          <div class="overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
              <thead>
                <tr>
                  <th
                    :for={col <- @col}
                    scope="col"
                    class="px-6 py-3 text-start text-xs font-medium text-gray-500 uppercase"
                  >
                    {col[:label]}
                  </th>
                </tr>
              </thead>
              <tbody
                id={@id}
                class="divide-y divide-gray-200"
                phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
              >
                <tr
                  :for={row <- @rows}
                  class={[@striped? && "odd:bg-white even:bg-gray-100"]}
                  id={@row_id && @row_id.(row)}
                >
                  <td
                    :for={{col, i} <- Enum.with_index(@col)}
                    phx-click={@row_click && @row_click.(row)}
                    class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800"
                  >
                    {render_slot(col, @row_item.(row))}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :id, :string, required: true, doc: "dom ID of clickable button"
  slot :option, required: true

  def dropdown(assigns) do
    ~H"""
    <div class="hs-dropdown relative inline-flex">
      <button
        id={@id}
        phx-hook="hs:dropdown"
        type="button"
        class="hs-dropdown-toggle py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 bg-white text-gray-800 shadow-2xs hover:bg-gray-50 focus:outline-hidden focus:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none"
        aria-haspopup="menu"
        aria-expanded="false"
        aria-label={@label}
      >
        {@label}
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
          <div
            :for={{option, i} <- Enum.with_index(@option)}
            class="gap-x-3.5 py-2 px-3 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100"
          >
            {render_slot(option)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :title, :string, default: nil

  attr :opened, :boolean,
    default: false,
    doc: "if true the modal will be immediately opened after mounting"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for the modal actions"

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 hidden size-full fixed top-0 start-0 z-80 opacity-0 overflow-x-hidden transition-all overflow-y-auto pointer-events-none"
      role="dialog"
      tabindex="-1"
      aria-labelledby={@id <> "-label"}
      phx-hook="hs:modal"
      data-opened={@opened}
    >
      <div class="sm:max-w-lg sm:w-full m-3 sm:mx-auto">
        <div class="flex flex-col bg-white border border-gray-200 shadow-2xs rounded-xl pointer-events-auto">
          <div class="flex justify-between items-center py-3 px-4 border-b border-gray-200">
            <h3 :if={@title} id={@id <> "-label"} class="font-bold text-gray-800">
              {@title}
            </h3>
            <button
              type="button"
              class="size-8 inline-flex justify-center items-center gap-x-2 rounded-full border border-transparent bg-gray-100 text-gray-800 hover:bg-gray-200 focus:outline-hidden focus:bg-gray-200 disabled:opacity-50 disabled:pointer-events-none"
              aria-label="Close"
              data-hs-overlay={@id}
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
          <div class="p-4 overflow-y-auto">
            {render_slot(@inner_block)}
          </div>
          <div class="flex justify-end items-center gap-x-2 py-3 px-4 border-t border-gray-200">
            {render_slot(@actions)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """



  """
  @doc ~S"""
  Opens a modal. Expects a string with the ID of the modal to show.

  ## Examples

      <button phx-click={open_modal("#my-modal")}>Opens a modal</button>
  """
  def open_modal(id) do
    JS.dispatch(%JS{}, "hs:show-modal", detail: %{id: id})
  end

  attr :style, :atom, default: :solid, values: [:solid, :outline, :ghost, :soft, :white, :link]
  attr :class, :string, default: ""
  attr :rest, :global
  slot :inner_block, required: true

  def button(assigns) do
    styles = %{
      solid:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-600 text-white hover:bg-blue-700 focus:outline-hidden focus:bg-blue-700 disabled:opacity-50 disabled:pointer-events-none",
      outline:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 text-gray-500 hover:border-blue-600 hover:text-blue-600 focus:outline-hidden focus:border-blue-600 focus:text-blue-600 disabled:opacity-50 disabled:pointer-events-none dark:border-neutral-700 dark:text-neutral-400 dark:hover:text-blue-500 dark:hover:border-blue-600 dark:focus:text-blue-500 dark:focus:border-blue-600",
      ghost:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent text-blue-600 hover:bg-blue-100 hover:text-blue-800 focus:outline-hidden focus:bg-blue-100 focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-500 dark:hover:bg-blue-800/30 dark:hover:text-blue-400 dark:focus:bg-blue-800/30 dark:focus:text-blue-400",
      soft:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent bg-blue-100 text-blue-800 hover:bg-blue-200 focus:outline-hidden focus:bg-blue-200 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-400 dark:hover:bg-blue-900 dark:focus:bg-blue-900",
      white:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-gray-200 bg-white text-gray-800 shadow-2xs hover:bg-gray-50 focus:outline-hidden focus:bg-gray-50 disabled:opacity-50 disabled:pointer-events-none dark:bg-neutral-800 dark:border-neutral-700 dark:text-white dark:hover:bg-neutral-700 dark:focus:bg-neutral-700",
      link:
        "py-3 px-4 inline-flex items-center gap-x-2 text-sm font-medium rounded-lg border border-transparent text-blue-600 hover:text-blue-800 focus:outline-hidden focus:text-blue-800 disabled:opacity-50 disabled:pointer-events-none dark:text-blue-500 dark:hover:text-blue-400 dark:focus:text-blue-400"
    }

    assigns = assign(assigns, :btn_classes, Map.get(styles, assigns.style))

    ~H"""
    <button type="button" class={[@btn_classes, @class]} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
