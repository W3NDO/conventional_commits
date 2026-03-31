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
    nb: :no_body,
    h: :help
  ]

  @switches [
    type: :string,
    footer: :boolean,
    no_body: :boolean,
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
      -t | --type : Accepts a string that defines the type of commit message. Allowed options are:
      \n\t#{inspect(Enum.map(@types, &(Atom.to_string(&1))))}\n
      -f | --footer : A boolean indicating whether the commit has a footer
      -nb | --no-body : A boolean indicating whether to include a body to the commit message. Default is false meaning that the commit will require a body.
    """
  end
end
