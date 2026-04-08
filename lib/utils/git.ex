defmodule Utils.Git do
  @moduledoc false
  def commit(msg) do
    tmp = Path.join(System.tmp_dir!(), "commit_msg.txt")
    File.write!(tmp, msg)
    {return_msg, return_code} = System.cmd("git", ["commit", "-F", tmp])

    case return_code do
      0 ->
        (IO.ANSI.light_green() <> return_msg <> IO.ANSI.reset())
        |> IO.puts()

      1 ->
        (IO.ANSI.red() <> return_msg <> IO.ANSI.reset())
        |> IO.puts()
    end
  end
end
