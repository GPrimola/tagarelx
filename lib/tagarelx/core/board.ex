defmodule Tagarelx.Core.Board do
  defstruct [:answer, guesses: []]

  @type t :: %__MODULE__{}
  @type word :: binary()

  @total_tries 6

  @spec new(answer :: word()) :: t()
  def new(answer)

  def new(answer) when is_binary(answer),
    do: %__MODULE__{answer: answer}

  @spec move(t(), word()) :: t()
  def move(%{guesses: guesses} = board, guess) when is_binary(guess),
    do: %{board | guesses: [guess | guesses]}

  @spec won?(t()) :: boolean()
  def won?(board)
  def won?(%{guesses: [guess | _rest], answer: answer}), do: guess == answer
  def won?(_board), do: false

  @spec lost?(t()) :: boolean()
  def lost?(%{guesses: guesses} = board), do: not won?(board) and length(guesses) == @total_tries

  @spec status(t()) :: %{lost?: boolean(), won?: boolean()}
  def status(board), do: %{won?: won?(board), lost?: lost?(board)}
end
