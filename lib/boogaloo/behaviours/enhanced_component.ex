defmodule Boogaloo.Behaviours.EnhancedComponent do
  alias Phoenix.LiveView

  @doc """
  Enhanced components inject some property and event handlers into the socket under a namespace

  TODO: add an example
  """

  @callback init(LiveView.Socket.t()) :: LiveView.Socket.t()
  @callback hooked_event(event :: binary(), LiveView.unsigned_params(), LiveView.Socket.t()) ::
              {:halt, LiveView.Socket.t()}
              | {:cont, LiveView.Socket.t()}
end
