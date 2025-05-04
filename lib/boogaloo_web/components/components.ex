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
end
