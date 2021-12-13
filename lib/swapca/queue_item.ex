defmodule Swapca.QueueItem do
  use GenServer, restart: :transient
  
  @retry_after Application.get_env(:swapca, :webhook_retry_after)
  @max_tries  Application.get_env(:swapca, :webhook_max_tries)
  @first_try 1 

  def init([msg_data, send_after]) do
    Process.send_after(self(), :run, send_after)
    {:ok, msg_data}
  end

  def start_link([msg_data, send_after]) do
    GenServer.start_link(__MODULE__, [msg_data, send_after])
  end

  def handle_info(:run, msg_data) do
    ret = Poison.encode!(msg_data)
    |> send_to_webhook(@first_try)

    {:stop, :normal, ret}
  end

  def send_to_webhook(msg_data, tries) when tries > @max_tries do
    IO.puts("Message content")
    IO.puts(msg_data)

    "Process failed trying to send message to webhook"
  end

  def send_to_webhook(msg_data, tries) do
    case Swapca.Webhook.send(msg_data) do
      {:error, msg} ->
        IO.puts(msg)
        :timer.sleep(@retry_after)
        send_to_webhook(msg_data, tries + 1)
      {:ok, msg} ->
          msg
    end
  end
end
