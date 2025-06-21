defmodule Boogaloo.Calculations.TruncatedText do
  use Ash.Resource.Calculation

  @string_length 200

  @impl true
  def calculate(records, _opts, _ctx) do
    Enum.map(records, fn record ->
      if String.length(record.body) > @string_length do
        Regex.run(~r/\A(.{0,#{@string_length}})(?:\w|\Z)/, record.body) |> hd()
      else
        record.body
      end
    end)
  end
end
