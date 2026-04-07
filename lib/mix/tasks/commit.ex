defmodule Mix.Tasks.Commit do
  @moduledoc """
  This will create a REPL that allows the user to create a commit message following specifications defined by [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) when the user requests `mix commit`.
  """

  @shortdoc "creates a conventional commit"

  use Mix.Task

  @types ~w(fix feat build chore ci docs style refactor perf test)a

  @aliases [
    t: :type,
    f: :footer,
    n: :no_body,
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
    case parse_args(args) do
      {:ok, :help} ->
        help_docs()

      {:ok, opts} ->
        opts
        |> build_repl_args()
        |> Utils.Cli.run_repl()
        |> make_commit()

      {:error, reason} ->
        {:error, reason}
    end
  end

  def parse_args(argv) do
    {opts, _args, invalid} = OptionParser.parse(argv, strict: @switches, aliases: @aliases)

    cond do
      invalid != [] ->
        {:error, "Invalid options: #{inspect(invalid)}"}

      Keyword.has_key?(opts, :help) == true ->
        {:ok, :help}

      Keyword.has_key?(opts, :type) && !valid_commit_types?(opts) ->
        {:error,
         "Unknown commit type. Allowed types are: [fix, feat, build, chore, ci, docs, style, refactor, perf, test]"}

      Keyword.has_key?(opts, :type) && valid_commit_types?(opts) ->
        {:ok, opts}

      true ->
        {:ok, opts}
    end
  end

  defp build_repl_args(opts) do
    config = %{
      type: Keyword.get(opts, :type),
      body: Keyword.get(opts, :body),
      footer: Keyword.get(opts, :footer)
    }

    user_config =
      if File.exists?(Path.join(File.cwd!(), ".commit.exs")) do
        {user_config, _} = Code.eval_file(".commit.exs")

          Enum.map(user_config, fn {k, v} -> Map.put(%{}, k, v) end)
          |> Enum.reduce(fn elem, acc -> Map.merge(elem, acc) end)
      else
        %{}
      end

    Map.merge(config, user_config)
  end

  defp valid_commit_types?(opts) do
    type_value = Keyword.get(opts, :type) |> String.to_atom()

    Enum.member?(@types, type_value)
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
      \n\t#{inspect(Enum.map(@types, &Atom.to_string(&1)))}\n
      -f | --footer : A boolean indicating whether the commit has a footer
      -nb | --no-body : A boolean indicating whether to include a body to the commit message. Default is false meaning that the commit will require a body.
    """
  end

  defp make_commit(state) do
    current_commit = format_commit(state)

    IO.puts("\nThis is your current commit:\n")
    IO.puts(colorize(current_commit))

    case confirm?("\nDo you want to commit? (y/yes/n/no): ") do
      true ->
        Utils.Git.commit(current_commit)

      false ->
        IO.puts("Commit aborted.")
        :ok
    end
  end

  defp format_commit(state) do
    """
    #{state.type}(#{state.scope}): #{state.description}

    #{state.body}
    #{state.footer}
    """
  end

  defp colorize(prompt) do
    IO.ANSI.light_green() <> prompt <> IO.ANSI.reset()
  end

  defp confirm?(prompt) do
    prompt
    |> IO.gets()
    |> normalize_input()
    |> case do
      "y" ->
        true

      "yes" ->
        true

      "n" ->
        false

      "no" ->
        false

      _ ->
        IO.puts("Invalid input. Please enter y/yes/n/no.")
        confirm?(prompt)
    end
  end

  defp normalize_input(nil), do: "\n"

  defp normalize_input(input) do
    input
    |> String.trim()
    |> String.downcase()
  end
end
