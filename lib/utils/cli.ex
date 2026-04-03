defmodule Utils.Cli do

  def run_repl(opts) do
    %Utils.State{
      type: Keyword.get(opts, :type, "feat"),
      scope: nil,
      body: nil,
      description: nil,
      footer: nil
    }

    |> enter_scope()
    |> enter_description()
    |> enter_body()
    |> enter_footer()

  end

  def enter_scope(state) do
    scope =
      """
        Enter the scope of this commit (eg `logging` becomes state(logging) ):
      """
      |> single_line_input()
    %Utils.State{state| scope: scope}
  end

  def enter_description(state) do
    description =
      """
      Enter the description of this commit. (eg. Refactored log processing to be lazy.)
      """
      |> single_line_input()

      %Utils.State{state | description: description}
  end

  def enter_body(state) do
    body =
      """
      Enter the body of this commit . This would define in-depth explanations of specific code changes in the commit. This can be a multiline entry.
      """
    |> multiline_input()

    %Utils.State{state | body: body}
  end

  def enter_footer(state) do
    footer =
      """
      This is a footer for your commit. It can be the PR your commit is referencing, the author or the reviewers. This can also be a multiline entry.
      """
    |> multiline_input()

    %Utils.State{state | footer: footer}
  end

  defp single_line_input(prompt) do
    input = IO.gets(prompt) |> String.trim()
  end

  def multiline_input(prompt) do
    IO.puts(prompt <> " (Enter empty line to finish): ")

    read_lines([])
  end

  def read_lines(acc) do
    case IO.gets("") do
      "\n" -> Enum.reverse(acc) |> Enum.join("\n")
      :eof -> Enum.reverse(acc) |> Enum.join("\n")
      line ->
        read_lines([String.trim_trailing(line, "\n") | acc])
    end
  end
end
