defmodule Tagarelx.Core.Board do
  defstruct [:answer, guesses: []]

  @type t :: %__MODULE__{}
  @type guess :: binary() | charlist()

  @total_tries 6

  @spec new(answer :: binary() | charlist()) :: t()
  def new(answer)

  def new(answer) when is_binary(answer),
    do:
      answer
      |> String.to_charlist()
      |> new()

  def new(answer) when is_list(answer) and length(answer) == 5,
    do: %__MODULE__{answer: answer}

  @spec move(t(), guess()) :: t()
  def move(board, guess)

  def move(board, guess) when is_binary(guess),
    do: move(board, String.to_charlist(guess))

  def move(%{guesses: guesses} = board, guess) when is_list(guess) and length(guess) == 5,
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
