defmodule Tagarelx.Core.Score do
  alias Tagarelx.Core.Board
  defstruct [:greens, :yellows, :grays]

  @type t :: %__MODULE__{}

  @spec new(%Board{}) :: t()

  def new(%Board{answer: answer, guesses: [guess | _rest]}), do: new(answer, guess)

  @spec new(binary(), binary()) :: t()
  def new(answer, guess)

  def new(answer, guess) when is_binary(answer) do
    answer
    |> String.to_charlist()
    |> new(guess)
  end

  def new(answer, guess) when is_binary(guess), do: new(answer, String.to_charlist(guess))

  def new(answer, guess) when is_list(answer) and is_list(guess),
    do: %__MODULE__{
      greens: greens(answer, guess),
      yellows: yellows(answer, guess),
      grays: grays(answer, guess)
    }

  def to_string(score),
    do: "Green: #{score.greens}, Yellow: #{score.yellows}, Gray: #{score.grays}"

  defp greens(answer, guess) do
    answer
    |> Enum.with_index()
    |> Enum.zip(Enum.with_index(guess))
    |> Enum.filter(fn {{a_letter, _}, {g_letter, _}} -> a_letter == g_letter end)
    |> Enum.map(fn {letter_position, _} -> letter_position end)
  end

  defp yellows(answer, guess) do
    greens = greens(answer, guess)
    grays = grays(answer, guess)

    guess
    |> Enum.with_index()
    |> Kernel.--(greens)
    |> Kernel.--(grays)
  end

  defp grays(answer, guess) do
    grays = guess -- answer

    guess
    |> Enum.with_index()
    |> Enum.reduce(grays, fn {letter, _pos} = letter_position, grays ->
      case letter in grays do
        true ->
          (grays -- [letter]) ++ [letter_position]

        false ->
          grays
      end
    end)
  end
end
