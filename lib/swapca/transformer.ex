defmodule Swapca.Transformer do
  use GenServer
  

  @me Transformer

  def init(user_input) do
    {:ok, user_input}
  end

  def start_link(user_input) do
    GenServer.start_link(__MODULE__, user_input, name: @me)    
  end

  def queue_up(user, repo) do
    GenServer.call(@me, {:queue_up, [user, repo]})
  end

  def handle_call({:queue_up, [user, repo]}, _client, _state) do
    case check_repo(user, repo) do
      {:ok} ->  
        process_transformation([user, repo])
        {:reply, "Data is being processed", [user, repo]}
      {:error, message} ->
        {:reply, message, [user, repo]} 
    end
  end

  defp check_repo(user, repo) do
    case Swapca.Github.validade_repo(user, repo) do
      {:error, error} ->
        {:error, "Error processing repository information. Message: #{error["message"]}"}
      _ -> {:ok}
    end
  end

  defp process_transformation(repo_info) do
    repo_info
    |> transform_request()
    |> send_to_output_queue()
  end

  defp transform_request([user, repo]) do
    %{"user" => user,
      "repository" => repo,
      "issues" => transform_issues(user, repo),
      "contributors" => transform_contributors(user, repo)
    }
  end

  defp transform_issues(user, repo) do
    Swapca.Github.get_issues(user, repo)
    |> Swapca.Formatter.format_issues()
  end

  defp transform_contributors(user, repo) do
    Swapca.Github.get_contributors(user, repo)
    |> Enum.map(&add_contributor_name(&1))
    |> Swapca.Formatter.format_contributors()
  end

  defp add_contributor_name(contributor) do
    user_data = Swapca.Github.get_user(contributor["login"])
    Map.put(contributor, "name", user_data["name"])
  end

  defp send_to_output_queue (data) do
    Swapca.QueueSupervisor.queue_up(data)
  end

end

