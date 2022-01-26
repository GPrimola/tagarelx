defmodule Tagarelx.Core.ScoreTest do
  use ExUnit.Case, async: true

  alias Tagarelx.Core.{Board, Score}

  describe "new/1" do
    test "should return a Score when a Board is given" do
      board = %Board{answer: "segue", guesses: ["guess"]}

      assert %Score{} = Score.new(board)
    end
  end

  describe "new/2" do
    test "should return Score with all greens when guess is like answer" do
      answer = 'answe'
      guess = 'answe'

      greens = Enum.with_index(answer)

      assert %Score{
               greens: ^greens,
               yellows: '',
               grays: ''
             } = Score.new(answer, guess)
    end

    test "should return Score with no greens when answer is 'answe' and guess is 'guess'" do
      answer = "answe"
      guess = "guess"

      yellows = [{?e, 2}, {?s, 4}]
      grays = [{?g, 0}, {?u, 1}, {?s, 3}]

      assert %Score{
               greens: '',
               yellows: ^yellows,
               grays: ^grays
             } = Score.new(answer, guess)
    end

    test "should return Score with all yellows when guess is an answer's anagram" do
      answer = "answe"
      guess = "swean"

      yellows = Enum.with_index('swean')

      assert %Score{
               greens: '',
               yellows: ^yellows,
               grays: ''
             } = Score.new(answer, guess)
    end
  end
end
