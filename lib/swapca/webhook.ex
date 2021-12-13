defmodule Swapca.Webhook do
  @doc """
  Facade dor Webhook
  """

  @webhook_url Application.get_env(:swapca, :webhook_url)

  # API
  def send(msg_data) do
    @webhook_url
    |> HTTPoison.post(msg_data)
    |> handle_response 
  end

  def handle_response({:ok, %{status_code: status_code}}) do
    {
      status_code |> check_for_error(),
      status_code |> check_for_error |> ret_msg
    }
  end

  def handle_response({:error, reason}) do
    IO.inspect(reason)
    {:error, "Error trying to send data to webhook #{reason["message"]}"}
  end

  defp check_for_error(201), do: :ok
  defp check_for_error(_), do: :error

  defp ret_msg(:ok), do: "Data sent to Webhook"
  defp ret_msg(:error), do: "Error trying to send data to webhook" 
end
