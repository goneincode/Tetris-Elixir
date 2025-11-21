defmodule Tetris.Board do
  @moduledoc """
  Handles the game board state.
  """

  def new do
    %{}
  end

  alias Tetris.Brick

  def merge(board, points, value \\ :occupied) do
    Enum.reduce(points, board, fn point, acc ->
      Map.put(acc, point, value)
    end)
  end

  def clear_lines(board) do
    {lines, new_board} =
      Enum.reduce(20..1//-1, {0, %{}}, fn y, {lines_cleared, acc_board} ->
        if full_row?(board, y) do
          {lines_cleared + 1, acc_board}
        else
          new_y = y + lines_cleared

          row_points =
            for x <- 1..10, Map.has_key?(board, {x, y}) do
              {{x, new_y}, board[{x, y}]}
            end
            |> Map.new()

          {lines_cleared, Map.merge(acc_board, row_points)}
        end
      end)

    {lines, new_board}
  end

  def full_row?(board, y) do
    Enum.all?(1..10, fn x -> Map.has_key?(board, {x, y}) end)
  end

  def to_string(board) do
    for y <- 1..20, x <- 1..10 do
      case Map.get(board, {x, y}) do
        nil -> " ."
        val -> " " <> Brick.char(val)
      end
    end
    |> Enum.chunk_every(10)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end
end
