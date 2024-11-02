defmodule Games do
  @moduledoc """
  Documentation for `Games`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Games.hello()
      :world

  """
  def hello do
    :world
  end

  defmodule GuessingGame do
    @moduledoc """
    Documentation for `guessing games`
    """

    def guess(no_of_tries, number) do
      case no_of_tries > 0 do
        false -> IO.puts("You failed! No more tries left. The number was #{number}")
        true ->
          {guess, _} = IO.gets("Please pick a number from 1 to 10: ") |> Integer.parse()
          if number === guess do
            "You got it right!, the number was #{number}"
          else
            IO.puts("You got it wrong! Try again!")
            cond do
              guess > number -> IO.puts("Too high")
              guess < number -> IO.puts("Too low!")
            end
            guess(no_of_tries - 1, number)
          end
      end
    end

    def play() do
      max_tries = 10

      number = Enum.random(1..10)

      guess(max_tries, number)
    end
  end


  defmodule RockPaperScissors do

    defp is_win?(attack1, attack2) do
      {attack1, attack2} in [
        {:rock, :scissors},
        {:paper, :rock},
        {:scissors, :paper}
      ]
    end

    def play() do
      player_choice = IO.gets("Choose rock, paper, or scissors: ") |> String.trim() |> String.downcase() |> String.to_atom() |> IO.inspect(label: 'player choice')

      computer_choice = Enum.random([:rock, :paper, :scissors]) |> IO.inspect(label: 'computer choice')

      cond do
        player_choice === computer_choice -> IO.puts("Draw! You both chose #{player_choice}")
        is_win?(player_choice, computer_choice) -> IO.puts("You win! You chose #{player_choice} and the computer chose #{computer_choice}")
        true -> IO.puts("You lost! You chose #{player_choice} and the computer chose #{computer_choice}")
      end
    end
  end
end

defmodule Games.Wordle do

  @word_list ["KNIFE", "BINGO", "BREAD", "BASTE", "CASTE"]
  @max_tries 5
  @word_length 5


  defp get_exact_matches(answer, guess) do
    Enum.zip(answer, guess)
    |> Enum.map(fn {answer, guess} ->
      if String.to_atom(answer) === String.to_atom(guess) do
        :green
      else
        guess
      end
    end)
  end

  defp get_partial_matches(answerWord, guessWord) do
    Enum.zip(answerWord, guessWord)
    |> Enum.map(fn {_answerLetter, guessLetter} ->
      cond do
        guessLetter === :green -> :green
        Enum.count(answerWord, fn x -> x === guessLetter end) > 0  -> :yellow
        true -> :red
      end
    end)
  end

  def feedback(answer, guess) do
    answer_chars = String.graphemes(answer)
    guess_chars = String.graphemes(guess)

    exact_matches = get_exact_matches(answer_chars, guess_chars)

    get_partial_matches(answer_chars, exact_matches)
  end

  defp get_valid_guess() do
    guess = IO.gets("\n Enter a #{@word_length}-letter word: ")
      |> String.trim()
      |> String.upcase()

      if String.length(guess) === @word_length do
        {:ok, guess}
      else
        {:error, :invalid_length}
      end
  end

  defp win?(result) do
    Enum.all?(result, fn x -> x === :green end)
  end

  defp display_win(tries) do
    IO.puts("\n#{IO.ANSI.green()}Congratulations! You won in #{@max_tries - tries + 1} tries!#{IO.ANSI.reset()}")
  end

  def handle_turn(0, answer) do
    IO.puts("\n#{IO.ANSI.red()}GAME OVER#{IO.ANSI.reset()} You lost! The word was #{IO.ANSI.bright()}#{answer}#{IO.ANSI.reset()}")
  end

  def handle_turn(tries, answer) do
    case get_valid_guess() do
      {:ok, guess} ->
        result = feedback(answer, guess)
        display_result(result, guess)
        if win?(result) do
          display_win(tries)
        else
          handle_turn(tries - 1, answer)
        end
      {:error, :invalid_length} ->
        IO.puts("\n#{IO.ANSI.red()}Please enter exactly #{@word_length} letters.#{IO.ANSI.reset()}")
        handle_turn(tries, answer)
    end
  end

  defp display_result(result, guess) do
    colored_letters =
      Enum.zip(result, String.graphemes(guess))
      |> Enum.map(fn {color, letter} ->
        case color do
          :green -> IO.ANSI.green() <> letter
          :yellow -> IO.ANSI.yellow() <> letter
          :red -> IO.ANSI.red() <> letter
        end <> IO.ANSI.reset()
      end)
      |> Enum.join("")

      IO.puts("\n#{colored_letters}")
  end

  def play() do
    answer = Enum.random(@word_list)

    IO.puts("\nWelcome to Wordle! You have #{@max_tries} tries to guess the #{@word_length}-letter word.")
    handle_turn(@max_tries, answer)
  end
end
