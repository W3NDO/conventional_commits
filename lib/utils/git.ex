defmodule Utils.Git do
  @moduledoc """
  Utilities for interacting with git locally.
  """

  def is_cached? do

  end

  def has_unstaged_changes? do

  end

  def get_unstaged_files do

  end

  def commit(msg) do
    tmp = Path.join(System.tmp_dir!(), "commit_msg.txt")
    File.write!(tmp, msg)
    {return_msg, return_code} = System.cmd("git", ["commit", "-F", tmp])
    case return_code do
      0 ->
        commit_msg = IO.ANSI.light_green() <> return_msg  <> IO.ANSI.reset()
        IO.puts(commit_msg)
      1 ->
        error = IO.ANSI.red() <> return_msg <> IO.ANSI.reset()
        IO.puts(error)
    end
  end
end
