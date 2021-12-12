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

  def handle_call({:queue_up, [user, repo]}, _cli, _) do
    # recuperar do github e informar o cliente em caso de erro
    transform_request(user, repo)
    |> send_to_output_queue() 
    # formatar os dados
    # jogar para fila 
    #
    {:reply, nil, [user, repo]}
  end

  defp transform_request(user, repo) do
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
    IO.inspect(data)
  end

end

