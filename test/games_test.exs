defmodule GamesTest do
  use ExUnit.Case
  doctest Games

  test "greets the world" do
    assert Games.hello() == :world
  end
end

defmodule Games.WordleTest do
    use ExUnit.Case
    doctest Games.Wordle

    test "All green" do
      assert Games.Wordle.feedback("AAAAA", "AAAAA") === [:green, :green, :green, :green, :green]
    end

    test "All yellow" do
      assert Games.Wordle.feedback("DBACE", "EDCBA") === [:yellow, :yellow, :yellow, :yellow, :yellow]
    end

    test "All red" do
      assert Games.Wordle.feedback("AAAAA", "XXXXX") === [:red, :red, :red, :red, :red]
    end

    test "Some green, some red, some yellow" do
      assert Games.Wordle.feedback("AAAAA", "AAXXY") === [:green, :green, :red, :red, :red]
    end
end
