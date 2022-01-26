defmodule Tagarelx.Core.Board do
  defstruct [:answer, guesses: []]

  @type t :: %__MODULE__{}

  @total_tries 6

  @spec new(answer :: binary()) :: t()
  def new(answer) when is_binary(answer),
    do: %__MODULE__{answer: answer}
end
