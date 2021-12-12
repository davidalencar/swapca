defmodule Swapca.Formatter do
  import Map, only: [take: 2, put: 3]
  import Enum, only: [map: 2]

  def format_issues(issues) when is_list(issues) do
    map(issues, &(format_issues(&1)))
  end

  def format_issues(issue) do
    formated = take(issue, ["title", "labels"])
    put(formated, "author", issue["user"]["login"])
  end

  def format_contributors(contributors) when is_list(contributors)  do
    map(contributors, &(format_contributors(&1)))
  end

  def format_contributors(contributor) do
    %{"name" => contributor["name"],
      "user" => contributor["login"],
      "qtd_commits" => contributor["contributions"]}
  end 
end
