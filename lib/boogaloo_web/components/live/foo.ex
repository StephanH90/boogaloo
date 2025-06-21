defmodule BoogalooWeb.Components.Live.Foo do
  use BoogalooWeb, :html
  import Phoenix.LiveView, only: [attach_hook: 4]
  @behaviour Boogaloo.Behaviours.EnhancedComponent

  def init(socket) do
    socket
    |> attach_hook(:sort, :handle_event, &hooked_event/3)
  end

  def foo(assigns) do
    ~H"""
    <div>{@clicked}</div>
    """
  end

  def hooked_event("sort", _params, socket) do
    dbg("IN HEREEEEEEEEEEEE")

    {:halt, assign(socket, :foo, "CLICKED!")}
  end

  def hooked_event(_, _, socket), do: {:cont, socket}
end
