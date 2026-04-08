defmodule Mix.Task.CommitTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  setup do
    :ok
  end

  # Weird styling is because of IO.ANSI
  test "raise error when no type flag is passed" do
    assert "\e[31mUSAGE ERROR: Type of commit flag (-t or --type) required. \e[0m\n" ==
             capture_io(fn -> Mix.Tasks.Commit.run([]) end)
  end

  # Weird styling is because of IO.ANSI
  test "raise error when invalid commit type options are passed" do
    assert "\e[31mUSAGE ERROR: Unknown commit type. Allowed types are: [fix, feat, build, chore, ci, docs, style, refactor, perf, test]\e[0m\n" ==
             capture_io(fn -> Mix.Tasks.Commit.run(["--type", "fixe"]) end)
  end
end
