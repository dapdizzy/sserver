defmodule Listener do
  use GenEvent

  # API
  def handle_event({:add, message}, messages) do
    {:ok, [message|messages]}
  end

  def handle_call(:messages, messages) do
    {:ok, messages |> Enum.reverse, messages}
  end
end
