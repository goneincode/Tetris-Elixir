defmodule TetrisTest do
  use ExUnit.Case
  doctest Tetris

  test "starts the game" do
    assert %Tetris.Game{} = Tetris.new_game()
  end
end
