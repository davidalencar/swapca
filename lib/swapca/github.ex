defmodule Swapca.Github do
  @moduledoc """
  Facade for Github's REST API
  """
  @github_url Application.get_env(:swapca,:github_url)
  @user_agent [{"User-agent", "davidalencarignacio@gmail.com"}]

  # API

  def get_issues(user, repo) do
    get_issues_url(user, repo)
    |> fetch_data()
  end

  def get_contributors(user, repo) do
    get_contributors_url(user, repo)
    |> fetch_data()
  end

  def get_user(user) do
    get_user_url(user)
    |> fetch_data()
  end

  # Implementation

  # URL
  defp build_url(endpoint = "users", user) do
    "#{@github_url}/#{endpoint}/#{user}"
  end

  defp build_url(endpoint = "repos", user, repo, entity) do
    "#{@github_url}/#{endpoint}/#{user}/#{repo}/#{entity}"
  end

  defp get_user_url(user), do: build_url("users", user)
  defp get_issues_url(user, repo), do: build_url("repos", user, repo, "issues")
  defp get_contributors_url(user, repo), do: build_url("repos", user, repo, "contributors")

  # Request
  defp fetch_data(url) do
    url
    |> HTTPoison.get(@user_agent)
    |> handle_response
    |> decode_response
  end

  # Response
  defp handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!() 
    }
  end

  defp handle_response({:error,%HTTPoison.Error{}}) do
    {
     :error,
     %{"message" => "Cold not hit GitHub API"}
    }
  end
  
  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error

  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    raise "Error fetching from Github: #{error["message"]}"
  end
end
