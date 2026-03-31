defmodule Mix.Task.Commit do
  @moduledoc """
  This will create a REPL that allows the user to create a commit message following specifications defined by [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when the user requests `mix commit`.
  """

  @shortdoc "creates a conventional commit"

  use Mix.Task

  @types ~w(fix feat build chore ci docs style refactor perf test)a

  @aliases [
    t: :type,
    f: :footer,
    h: :help
  ]

  @switches [
    type: :string,
    footer: :boolean,
    help: :boolean
  ]

  @impl Mix.Task
  def run(args) do
    parse_args(args)
  end

  def parse_args(argv) do
    {opts, _args, invalid} = OptionParser.parse(argv, strict: @switches, aliases: @aliases)

    cond do
      invalid != [] ->
        {:error, "Invalid options: #{inspect(invalid)}"}

      Keyword.get(opts, :help) == true ->
        {:ok, help_docs()}

      Enum.member?(@types, Keyword.get(opts, :type) |> String.downcase() |> String.to_atom) == true ->
        {:ok, opts}

      true ->
        {:ok, opts}
    end
  end

  defp help_docs do
    """
    NAME
    `mix commit` - Mix task allowing for conventional commits

    SYNOPSIS
      `mix commit [OPTIONS]`

    DESCRIPTION
      Opens a REPL allowing users to interactively write commit messages that conform to conventional commits as specified here:   https://www.conventionalcommits.org/en/v1.0.0/

    OPTIONS
      -h | --help : Opens this message
    """
  end
end
