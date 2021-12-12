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
    user_name = parse_param(IO.read(:stdio, :line))

    IO.puts("Agora informe o nome do repositório:")

    repo  = parse_param(IO.read(:stdio, :line))

    IO.puts("Carregando dados do repositório #{user_name}/#{repo}")
    get_user_input()
  end

  def parse_param(param) do
    String.trim(param)
  end

end
