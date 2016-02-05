defmodule SimpleNoteList do
  use GenServer

  defstruct event_manager: nil, notes: %{}

  def start_link(initial_state, name) do
    GenServer.start_link(SimpleNoteList, initial_state, name: name)
  end

  def init(greeting_message) do
    {:ok, %SimpleNoteList{event_manager: GenEvent.start_link(), notes: %{everyone: greeting_message}}}
  end

  def addNote(server, note) do
    GenServer.call(server, {:addNote, note})
  end

  def list(server) do
    GenServer.call(server, :list)
  end

  def handle_call({:addNote, note = %Note{message: message}}, _from, %SimpleNoteList{event_manager: event_manager, notes: notes} = state) do
    IO.puts "Received note: #{note}"
    GenEvent.notify(event_manager, {:add, message})
    {:reply, "You wrote #{note}", %{state| notes: notes|> Notes.addNote(note)}}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def addListener(server, listener) do
    GenServer.call(server, {:add_listener, listener})
  end

  def handle_call({:add_listener, listener = {module, node}}, _from, %SimpleNoteList{event_manager: event_manager} = state) do
    event_manager |> GenEvent.add_handler(listener, Notes.getNodes(notes, :everyone) ++ Notes.getNotes(notes, node)) # Add initial set of messages to this listener
  end
end
