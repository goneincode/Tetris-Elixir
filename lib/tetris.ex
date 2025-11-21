defmodule Tetris do
  @moduledoc """
  Documentation for `Tetris`.
  """

  alias Tetris.Game

  @doc """
  Starts a new Tetris game.
  """
  def new_game do
    Game.new()
  end

  def play do
    # Set terminal to raw mode. This disables buffering and echoing.
    # We must manually handle \r\n for newlines.
    System.cmd("stty", ["raw", "-echo"])

    try do
      pid = self()
      spawn_link(fn -> input_loop(pid) end)

      new_game()
      |> game_loop()
    after
      # Restore terminal settings
      System.cmd("stty", ["sane"])
      # Reset cursor and clear screen
      IO.write("\e[H\e[J")
    end
  end

  defp input_loop(game_pid) do
    case IO.getn("", 1) do
      :eof ->
        :ok

      # Ctrl+C
      "\u0003" ->
        send(game_pid, {:input, "q"})

      char ->
        send(game_pid, {:input, char})
        input_loop(game_pid)
    end
  end

  defp game_loop(game) do
    # Clear screen
    IO.write("\e[H\e[J")
    Game.render(game)
    IO.write("Score: #{game.score}\r\n")
    IO.write("Controls: a(left), d(right), w(rotate), s(down), q(quit)\r\n")

    receive do
      {:input, "q"} ->
        IO.write("Game Over!\r\n")

      {:input, input} ->
        new_game = handle_input(game, input)
        game_loop(new_game)
    after
      333 ->
        new_game = Game.down(game)
        game_loop(new_game)
    end
  end

  defp handle_input(game, "a"), do: Game.left(game)
  defp handle_input(game, "d"), do: Game.right(game)
  defp handle_input(game, "w"), do: Game.rotate(game)
  defp handle_input(game, "s"), do: Game.down(game)
  defp handle_input(game, _), do: game
end
