defmodule Swapca.QueueItem do
  use GenServer, restart: :transient

  def init([msg_data, send_after]) do
    Process.send_after(self(), :run, send_after)
    {:ok, [msg_data]}
  end

  def start_link([msg_data, send_after]) do
    GenServer.start_link(__MODULE__, [msg_data, send_after])
  end

  def handle_info(:run, msg_data) do
    IO.puts("Enviando para webhook")
    IO.inspect(msg_data)
    {:stop, :normal, nil}
  end

end
