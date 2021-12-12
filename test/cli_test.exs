defmodule CliTest do
  use ExUnit.Case

  import Swapca.Cli

  test "parase_param: Must trim the param value" do
    assert parse_param("value  ") == "value"
  end

end
