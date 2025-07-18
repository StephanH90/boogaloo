defmodule BoogalooWeb.EmbeddedEmber do
  use BoogalooWeb, :live_view

  defp live_view_routes(), do: ~w(/work-items)

  @impl true
  def mount(_params, _session, socket) do
    [header_content, body_content] = get_ember_content()
    {:ok, assign(socket, header: header_content, body: body_content), layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <a href={~p"/blogs/"} >Go to blogs</a>
      <div
        id="embedded-ember-container"
        data-live-view-routes={Enum.join(live_view_routes(), ",")}
        phx-update="ignore"
        phx-hook="EmbeddedEmber"
      >
        <div id="ember-ebau-header">
          {raw(@header)}
        </div>
        <div id="ember-ebau-body">
          {raw(@body)}
        </div>
      </div>
    </div>
    """
  end

  defp get_ember_content() do
    %{body: body} = Req.get!("http://localhost:4200")

    Enum.map(["head", "body"], fn elem ->
      elem |> get_elem(body) |> Floki.raw_html()
    end)
  end

  defp get_elem(elem, dom) do
    case Floki.find(dom, elem) do
      [head_element | _] ->
        # Get the raw HTML of the entire element and its contents
        head_element
        |> prefix_assets("http://localhost:4200")
        |> dbg()

      [] ->
        nil
    end
  end

  defp prefix_assets({tag, attrs, children}, prefix) when is_list(children) do
    new_attrs =
      Enum.map(attrs, fn
        {"src", <<"/assets/", _::binary>> = path} -> {"src", prefix <> path}
        other -> other
      end)

    {tag, new_attrs, Enum.map(children, &prefix_assets(&1, prefix))}
  end

  # Skip over leaf strings / atoms / anything else
  defp prefix_assets(other, _prefix), do: other
end
