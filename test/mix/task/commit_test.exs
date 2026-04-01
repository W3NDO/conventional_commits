defmodule Mix.Task.CommitTest do
  use ExUnit.Case

  setup do
    :ok
  end

  test "shows a help message" do
    {:ok, help_message} = Mix.Tasks.Commit.run(["-h"])

    {:ok, help_message_2} = Mix.Tasks.Commit.run(["--help"])

    assert help_message == help_message_2

    assert help_message == """
           NAME
           `mix commit` - Mix task allowing for conventional commits

           SYNOPSIS
             `mix commit [OPTIONS]`

           DESCRIPTION
             Opens a REPL allowing users to interactively write commit messages that conform to conventional commits as specified here:   https://www.conventionalcommits.org/en/v1.0.0/

           OPTIONS
             -h | --help : Opens this message
             -t | --type : Accepts a string that defines the type of commit message. Allowed options are:
             \n\t[\"fix\", \"feat\", \"build\", \"chore\", \"ci\", \"docs\", \"style\", \"refactor\", \"perf\", \"test\"]\n
             -f | --footer : A boolean indicating whether the commit has a footer
             -nb | --no-body : A boolean indicating whether to include a body to the commit message. Default is false meaning that the commit will require a body.
           """
  end

  test "raise error when invalid commit type options are passed" do
    {:error, invalid_options_message} = Mix.Tasks.Commit.run(["--type", "fixe"])

    assert invalid_options_message ==
             "Unknown commit type. Allowed types are: [fix, feat, build, chore, ci, docs, style, refactor, perf, test]"
  end

  test "Opts include footer flag, no_body flag and commit type" do
    {:ok, opts} = Mix.Tasks.Commit.run(["--type", "fix", "-n", "-f"])

    assert opts == [{:type, "fix"}, {:no_body, true}, {:footer, true}]
  end
end
