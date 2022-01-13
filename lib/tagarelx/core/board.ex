defmodule Tagarelx.Core.Board do
  defstruct [:answer, guesses: []]

  @type t :: %__MODULE__{}
  @type guess :: binary()

  @total_tries 6

  @spec new(answer :: binary()) :: t()
  def new(answer) when is_binary(answer),
    do: %__MODULE__{answer: answer}

  def new(answer) when is_list(answer) and length(answer) == 5,
    do: %__MODULE__{answer: answer}

  @spec move(t(), guess()) :: t()
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
