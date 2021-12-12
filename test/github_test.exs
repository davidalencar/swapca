defmodule GithubTest do
  use ExUnit.Case

  test "Should return one issue for davidalencar/spca_test" do
    data = Swapca.Github.get_issues("davidalencar", "spca_test")
    assert length(data) == 1
  end

  test "Should return one contributor for davidalencar/spca_test" do
    data = Swapca.Github.get_contributors("davidalencar", "spca_test")
    assert length(data) == 1
  end

  test "Shoud return one user dor davidalencar" do
    data = Swapca.Github.get_user("davidalencar")
    assert data["login"] == "davidalencar"
  end

  assert_raise RuntimeError, "Error fetching from Github: Not Found", fn ->
    Swapca.Github.get_issues("", "")
  end
end
