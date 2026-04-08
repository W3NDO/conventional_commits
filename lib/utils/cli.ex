defmodule Utils.Cli do
  @moduledoc """
  A collection of functions that control how the mix task REPL works.
  """
  def run_repl(opts) do
    state = build_initial_state(opts)
    # Check if scope is required and enter it or continue
    state =
      case Map.get(state, :scoped, false) do
        false ->
          state

        true ->
          enter_scope(state)
      end
      # Description is mandatory
      |> enter_description()

    # check if body is required and enter it
    state =
      case Map.get(state, :required_body, false) do
        false ->
          state

        true ->
          enter_body(state)
      end

    state =
      case Map.get(state, :required_footer, false) do
        false ->
          state

        true ->
          footer_fields = Map.get(opts, :footer_fields, [])
          enter_footer(state, footer_fields)
      end

    state
  end

  def enter_scope(state) do
    scope =
      "Enter the scope of this commit: "
      |> single_line_input("SCOPE")

    %{state | scope: scope}
  end

  def enter_description(state) do
    description =
      "Enter the description of this commit: "
      |> single_line_input("DESCRIPTION")

    %{state | description: description}
  end

  def enter_body(state) do
    body =
      """
      Enter the body of this commit . This would define in-depth explanations of specific code changes in the commit. This can be a multiline entry.
      """
      |> multiline_input("BODY")

    %{state | body: body}
  end

  def enter_footer(state, footer_fields \\ []) do
    case Enum.empty?(footer_fields) do
      true ->
        footer =
          """
          This is a footer for your commit. It can be the PR your commit is referencing, the author or the reviewers. This can also be a multiline entry.
          """
          |> multiline_input("FOOTER")

        %{state | footer: footer}

      false ->
        formatted_footer_fields =
          footer_fields
          |> Enum.map(
            &(Atom.to_string(&1)
              |> String.capitalize())
          )

        footer =
          """
          Your .commit.exs specifies that you are required to enter the following fields in your footer:  #{inspect(formatted_footer_fields)}

          For example:

          #{inspect(hd(formatted_footer_fields))}: <Your Value here>\n
          """
          |> multiline_input("FOOTER")

        %{
          state
          | footer:
              "#{if state.breaking_change_in_footer, do: "BREAKING CHANGE!\n", else: ""}" <>
                footer
        }
    end
  end

  defp single_line_input(prompt, title) do
    ansi_title = backgroundize("\t" <> title)
    ansi_prompt = colorize(prompt)

    IO.puts(ansi_title)

    IO.gets(ansi_prompt)
    |> String.trim()
  end

  def multiline_input(prompt, title) do
    ansi_title = backgroundize("\t" <> title)
    ansi_prompt = colorize(prompt <> "(Enter empty line to finish): ")
    IO.puts(ansi_title)
    IO.puts(ansi_prompt)

    read_lines([])
  end

  def read_lines(acc) do
    case IO.gets("") do
      "\n" ->
        Enum.reverse(acc) |> Enum.join("\n")

      :eof ->
        Enum.reverse(acc) |> Enum.join("\n")

      line ->
        read_lines([String.trim_trailing(line, "\n") | acc])
    end
  end

  defp build_initial_state(opts) do
    %Utils.State{
      type: Map.get(opts, :type, "feat"),
      scope: nil,
      body: nil,
      description: nil,
      footer: nil,
      required_footer: Map.get(opts, :required, []) |> Enum.member?(:footer),
      required_body: Map.get(opts, :required, []) |> Enum.member?(:body),
      scoped: Map.get(opts, :required, []) |> Enum.member?(:scope),
      breaking: Map.get(opts, :breaking, false),
      breaking_change_in_footer: Map.get(opts, :breaking_change_in_footer, false)
    }
  end

  defp colorize(prompt) do
    IO.ANSI.light_cyan() <> prompt <> IO.ANSI.reset()
  end

  def backgroundize(title) do
    IO.ANSI.blue_background() <> IO.ANSI.underline() <> title <> IO.ANSI.reset()
  end
end
