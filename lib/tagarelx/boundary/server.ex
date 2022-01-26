defmodule Tagarelx.Boundary.Server do
  use GenServer
  alias Tagarelx.Core.{Board, Score}

  @words_file "priv/pt_BR.txt"

  def start_link(name) do
    answer =
      @words_file
      |> File.stream!()
      |> Enum.random()
      |> String.trim()
      |> String.downcase()

    opts = [answer: answer]
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def move(name, guess) do
    GenServer.cast(name, {:move, guess})
  end

  @impl true
  def init(answer: answer) do
    {:ok, Board.new(answer)}
  end

  @impl true
  def handle_cast({:move, guess}, board) do
    new_board =
      case Board.status(board) do
        %{won?: true} ->
          IO.puts("You've WON!")
          board

        %{lost?: true} ->
          IO.puts("You've lost!")
          board

        _ ->
          Board.move(board, guess)
      end

    new_board
    |> Score.new()
    |> Score.print()

    {:noreply, new_board}
  end
end
