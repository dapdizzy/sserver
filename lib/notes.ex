defmodule Notes do
  def getNotes(notes = %{}, receiver) do
    receiverNotes = notes[receiver]
    cond do
      receiverNotes |> is_list -> receiverNotes
      true -> []
    end
  end

  def addNote(notes = %{}, note = %Note{to: receiver}) do
    notes |> Map.put(receiver, [note|notes |> getNotes(receiver)])
  end
end
