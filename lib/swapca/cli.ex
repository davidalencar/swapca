defmodule Swapca.Cli do
  use GenServer
  import Swapca.Transformer

  @me Cli

  def init(_) do
    Process.send_after(self(), :start, 0)
    {:ok, nil}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @me)
  end

  def handle_info(:start, _) do
    get_user_input()
  end

  def get_user_input() do
    IO.puts("--------------------------")
    IO.puts("Enter the GitHub username:")
    user = read_line()

    IO.puts("Enter the repository name:")
    repo  = read_line()

    IO.puts("Response:")
    queue_up(user, repo)
    |> IO.puts()

    get_user_input()
  end

  def read_line() do
    IO.read(:stdio, :line)
            |> parse_param()
            |> validade()
  end 

  def parse_param(param) do
    String.trim(param)
  end

  def validate("") do
    raise "Valor inválido"
  end

  def validade(param), do: param
end
