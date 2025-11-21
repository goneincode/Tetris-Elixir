defmodule Tetris.Game do
  @moduledoc """
  The core game loop and state management.
  """

  defstruct [:brick, :board, :score, :level, :game_over]

  alias Tetris.{Brick, Board, Points}

  def new do
    %__MODULE__{
      brick: Brick.new_random(),
      board: Board.new(),
      score: 0,
      level: 1,
      game_over: false
    }
  end

  def left(game), do: move(game, &Brick.left/1)
  def right(game), do: move(game, &Brick.right/1)
  def rotate(game), do: move(game, &Brick.spin_90/1)

  def down(game) do
    new_brick = Brick.down(game.brick)

    if valid?(game, new_brick) do
      %{game | brick: new_brick}
    else
      # Landed
      points = Brick.prepare(game.brick)
      board_with_brick = Board.merge(game.board, points, game.brick.name)

      {lines_cleared, new_board} = Board.clear_lines(board_with_brick)
      points_earned = Points.calculate_score(lines_cleared, game.level)

      %{game | board: new_board, brick: Brick.new_random(), score: game.score + points_earned}
    end
  end

  defp move(game, transform_fn) do
    new_brick = transform_fn.(game.brick)

    if valid?(game, new_brick) do
      %{game | brick: new_brick}
    else
      game
    end
  end

  def valid?(game, brick) do
    points = Brick.prepare(brick)
    Enum.all?(points, fn point -> valid_point?(game.board, point) end)
  end

  def valid_point?(board, {x, y}) do
    x in 1..10 and y in 1..20 and not Map.has_key?(board, {x, y})
  end

  def render(game) do
    points = Brick.prepare(game.brick)

    game.board
    |> Board.merge(points, game.brick.name)
    |> Board.to_string()
    |> String.replace("\n", "\r\n")
    |> IO.write()

    IO.write("\r\n")
  end
end
