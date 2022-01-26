defmodule Tagarelx.Core.BoardTest do
  use ExUnit.Case, async: true

  alias Tagarelx.Core.Board

  describe "new/1" do
    test "should return a Board struct with no guesses when the provided answer is binary" do
      answer = "answe"

      board = Board.new(answer)

      assert %Board{answer: ^answer, guesses: []} = board
    end
  end
end
