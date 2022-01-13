defmodule Tagarelx.Core.BoardTest do
  use ExUnit.Case, async: true

  alias Tagarelx.Core.Board

  describe "new/1" do
    test "should return a Board struct with no guesses when the provided answer is list" do
      answer = ['a', 'n', 's', 'w', 'e']

      board = Board.new(answer)

      assert %Board{answer: ^answer, guesses: []} = board
    end

    test "should return a Board struct with no guesses when the provided answer is string" do
      answer_str = "answe"
      answer = String.to_charlist(answer_str)

      board = Board.new(answer_str)

      assert %Board{answer: ^answer, guesses: []} = board
    end
  end

  describe "move/2" do
    test "should add a guess to board's guesses list when given guess is charlist" do
      answer = "answe"
      guess = ['g', 'u', 'e', 's', 's']

      board =
        Board.new(answer)
        |> Board.move(guess)

      assert %Board{guesses: [^guess]} = board
    end

    test "should convert a guess to charlist and add it to board's guesses list when given guess is binary" do
      answer = "answe"
      guess_str = "guess"
      guess = String.to_charlist(guess_str)

      board =
        Board.new(answer)
        |> Board.move(guess_str)

      assert %Board{guesses: [^guess]} = board
    end
  end

  describe "won?/1" do
    test "should return false when board's guesses is empty" do
      answer = "answe"

      board = Board.new(answer)

      refute Board.won?(board)
    end

    test "should return false when guess is not like answer" do
      answer = "answe"

      refute Board.new(answer)
             |> Board.move("guess")
             |> Board.won?()
    end

    test "should return true when guess is like answer" do
      answer = "answe"

      assert Board.new(answer)
             |> Board.move("answe")
             |> Board.won?()
    end
  end

  describe "lost?/1" do
    test "should return false when board's guesses is empty" do
      answer = "answe"

      board = Board.new(answer)

      refute Board.lost?(board)
    end

    test "should return false when guess is like answer" do
      answer = "answe"

      refute Board.new(answer)
             |> Board.move("answe")
             |> Board.lost?()
    end

    test "should return true when guess is not like answer and guesses has 6 tries" do
      answer = "answe"

      assert Board.new(answer)
             |> Board.move("one  ")
             |> Board.move("two  ")
             |> Board.move("three")
             |> Board.move("four ")
             |> Board.move("five ")
             |> Board.move("six  ")
             |> Board.lost?()
    end
  end

  describe "status/1" do
    test "should return status of the board when just created" do
      answer = "answe"

      board_status =
        Board.new(answer)
        |> Board.status()

      refute board_status.lost?
      refute board_status.won?
    end

    test "should return status of the board when win" do
      answer = "answe"

      board_status =
        answer
        |> Board.new()
        |> Board.move("answe")
        |> Board.status()

      refute board_status.lost?
      assert board_status.won?
    end

    test "should return status of the board when lost" do
      answer = "answe"

      board_status =
        answer
        |> Board.new()
        |> Board.move("one  ")
        |> Board.move("two  ")
        |> Board.move("three")
        |> Board.move("four ")
        |> Board.move("five ")
        |> Board.move("six  ")
        |> Board.status()

      assert board_status.lost?
      refute board_status.won?
    end
  end
end
