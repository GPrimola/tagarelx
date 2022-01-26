defmodule Tagarelx do
  @moduledoc """
  Documentation for `Tagarelx`.
  """
  alias Tagarelx.Boundary.Server, as: Game

  def add_game(name) when is_binary(name),
    do: add_game(String.to_atom(name))

  def add_game(name) do
    DynamicSupervisor.start_child(MultiplayerServer, {Game, name})
  end
end
