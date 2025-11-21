defmodule Tetris.Brick do
  @moduledoc """
  Handles the logic for Tetris bricks (tetrominos).
  """

  defstruct [:name, :rotation, :reflection, :location]

  def new_random do
    new(random_name())
  end

  def new(name) do
    %__MODULE__{
      name: name,
      rotation: 0,
      reflection: false,
      location: {4, 0}
    }
  end

  def left(brick) do
    {x, y} = brick.location
    %{brick | location: {x - 1, y}}
  end

  def right(brick) do
    {x, y} = brick.location
    %{brick | location: {x + 1, y}}
  end

  def down(brick) do
    {x, y} = brick.location
    %{brick | location: {x, y + 1}}
  end

  def spin_90(brick) do
    %{brick | rotation: rem(brick.rotation + 90, 360)}
  end

  def prepare(brick) do
    brick
    |> points()
    |> rotate(brick.rotation)
    |> move(brick.location)
  end

  def points(brick) do
    shape(brick.name)
  end

  def rotate(points, 0), do: points

  def rotate(points, 90) do
    Enum.map(points, fn {x, y} -> {y, 5 - x} end)
  end

  def rotate(points, 180) do
    points
    |> rotate(90)
    |> rotate(90)
  end

  def rotate(points, 270) do
    points
    |> rotate(180)
    |> rotate(90)
  end

  def move(points, {dx, dy}) do
    Enum.map(points, fn {x, y} -> {x + dx, y + dy} end)
  end

  def random_name do
    ~w(i l z o t s j)a
    |> Enum.random()
  end

  def char(:i), do: "▒"
  def char(:l), do: "▓"
  def char(:j), do: "░"
  def char(:o), do: "█"
  def char(:z), do: "▚"
  def char(:s), do: "▞"
  def char(:t), do: "▣"
  def char(_), do: "■"

  def shape(:l) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def shape(:j) do
    [
      {3, 1},
      {3, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def shape(:o) do
    [
      {2, 2},
      {3, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def shape(:z) do
    [
      {2, 2},
      {3, 2},
      {3, 3},
      {4, 3}
    ]
  end

  def shape(:s) do
    [
      {3, 2},
      {4, 2},
      {2, 3},
      {3, 3}
    ]
  end

  def shape(:t) do
    [
      {2, 2},
      {3, 2},
      {4, 2},
      {3, 3}
    ]
  end

  def shape(:i) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4}
    ]
  end
end
