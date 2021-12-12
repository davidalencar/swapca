defmodule FormatterTest do
  use ExUnit.Case

  import Swapca.Formatter
  import Enum, only: [sort: 1]
  import Map, only: [keys: 1]

  @issue_fields ["title", "author", "labels"]
  @contributor_fields ["name", "user", "qtd_commits"]
 
  def get_json(filename) do
    File.read!(filename)
    |> Poison.Parser.parse!      
  end
  
  def get_issue() do
     get_json("./test/seed/issue.json")
  end

  def get_contributor() do
    get_json("./test/seed/contributor.json")
  end


  test "Should transform issue" do
    issue_formated = get_issue()
                     |> format_issues()

    assert issue_formated |> keys |> sort == @issue_fields |> sort
    assert issue_formated["author"] == "davidalencar"
    assert issue_formated["title"] == "Test"
    assert length(issue_formated["labels"]) == 2
  end

  test "Should transform a list of issues" do
    issue = get_issue()
    list_formated = [issue, issue, issue]
                    |>format_issues()

    assert length(list_formated) == 3    
  end

  test "Should transform a contributor" do
    contributor_formated = get_contributor()
                           |> format_contributors()

    
    assert contributor_formated |> keys |> sort == @contributor_fields |> sort

  end
end
