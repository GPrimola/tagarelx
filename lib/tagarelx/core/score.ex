defmodule Tagarelx.Core.Score do
  alias Tagarelx.Core.Board
  defstruct [:greens, :yellows, :grays]

  @type t :: %__MODULE__{}

  @spec new(%Board{}) :: t()

  def new(%Board{answer: answer, guesses: [guess | _rest]}), do: new(answer, guess)

  @spec new(binary() | charlist(), binary() | charlist()) :: t()
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

  @spec to_str(%__MODULE__{}) :: binary()
  def to_str(%__MODULE__{grays: grays, greens: greens, yellows: yellows}) do
    """
      Grays: #{Enum.map(grays, &elem(&1, 1)) |> Enum.join(", ")}
      Greens: #{Enum.map(greens, &elem(&1, 1)) |> Enum.join(", ")}
      Yellows: #{Enum.map(yellows, &elem(&1, 1)) |> Enum.join(", ")}\
    """
  end

  @spec print(%__MODULE__{}) :: :ok
  def print(%__MODULE__{grays: grays, greens: greens, yellows: yellows}) do
    gray =
      Enum.map(grays, fn {letter, position} ->
        {"#{IO.ANSI.color_background(244)}#{List.to_string([letter])}#{IO.ANSI.reset()}",
         position}
      end)

    green =
      Enum.map(greens, fn {letter, position} ->
        {"#{IO.ANSI.green_background()}#{List.to_string([letter])}#{IO.ANSI.reset()}", position}
      end)

    yellow =
      Enum.map(yellows, fn {letter, position} ->
        {"#{IO.ANSI.yellow_background()}#{List.to_string([letter])}#{IO.ANSI.reset()}", position}
      end)

    (gray ++ green ++ yellow)
    |> Enum.sort(&(elem(&1, 1) <= elem(&2, 1)))
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
    |> IO.puts()
  end

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
    guess
    |> Enum.with_index()
    |> Enum.reduce(answer, fn {letter, _pos} = letter_position, answer ->
      case letter in answer do
        true ->
          answer -- [letter]

        false ->
          (answer -- [letter]) ++ [letter_position]
      end
    end)
    |> Enum.filter(&is_tuple/1)
  end
end
