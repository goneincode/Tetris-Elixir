defmodule Tetris.Points do
  @moduledoc """
  Handles scoring logic for Tetris.
  """

  def calculate_score(lines_cleared, level) do
    case lines_cleared do
      1 -> 40 * (level + 1)
      2 -> 100 * (level + 1)
      3 -> 300 * (level + 1)
      4 -> 1200 * (level + 1)
      _ -> 0
    end
  end
end
