defmodule Swapca.Cli do
  use GenServer

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
    IO.puts("""
      --------------------------
      Entre com o nome do usuário no GitHub:
      """)
    user = read_line()

    IO.puts("Agora informe o nome do repositório:")
    repo  = read_line()

    Swapca.Transformer.queue_up(user, repo)

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
