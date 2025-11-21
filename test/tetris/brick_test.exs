defmodule Tetris.BrickTest do
  use ExUnit.Case
  alias Tetris.Brick

  test "creates a new brick" do
    brick = Brick.new(:i)
    assert brick.name == :i
    assert brick.location == {4, 0}
  end
end
