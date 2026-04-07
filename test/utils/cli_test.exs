defmodule Utils.CliTest do
  use ExUnit.Case # Because we are dealing with cpature_io, we run these tests synchronously so we don't capture output from other tests. (https://hexdocs.pm/ex_unit/1.12/ExUnit.CaptureIO.html)

  import ExUnit.CaptureIO
  alias Utils.Cli

  setup do
    state = %Utils.State{
      type: "feat",
      scope: nil,
      body: nil,
      description: nil,
      footer: nil
    }

    {:ok, state: state}
  end

  test "enter_scope/1 expects input and return updated state", %{state: state} do
    capture_io("This is the commit scope",
      fn ->
        assert Cli.enter_scope(state) |> Map.get(:scope) == "This is the commit scope"
      end)
  end

  test "enter_description/1 expects input and return updated state", %{state: state} do
    capture_io("This is the commit description",
      fn ->
        assert Cli.enter_description(state) |> Map.get(:description) == "This is the commit description"
      end)
  end

  test "enter_body/1 expects input and return updated state", %{state: state} do
    capture_io("This is the commit body",
      fn ->
        assert Cli.enter_body(state) |> Map.get(:body) == "This is the commit body"
      end)
  end

  test "enter_body/1 accepts multiline input and return updated state", %{state: state} do
    multiline_body = "This is a sample of a multiline body\nIt should end with `\\n\\n`"
    capture_io(multiline_body,
      fn ->
        assert Cli.enter_body(state) |> Map.get(:body) == multiline_body
      end)

    invalid_multiline_body = "This is a bad multiline.\n\nThis will be ignored"
    capture_io(invalid_multiline_body,
      fn ->
        assert Cli.enter_body(state) |> Map.get(:body) == "This is a bad multiline."
      end)
  end

  test "enter_footer/1 expects input and return updated state", %{state: state} do
    capture_io("This is the commit footer",
      fn ->
        assert Cli.enter_footer(state) |> Map.get(:footer) == "This is the commit footer"
      end)
  end

  test "enter_footer/1 accepts multiline input and return updated state", %{state: state} do
    multiline_footer = "Author: W3NDO\nREF: #123\n"
    capture_io(multiline_footer,
      fn ->
        assert Cli.enter_footer(state) |> Map.get(:footer) == multiline_footer |> String.trim()
      end)

    invalid_multiline_footer = "Author: W3NDO\n\nThis will be ignored"
    capture_io(invalid_multiline_footer,
      fn ->
        assert Cli.enter_footer(state) |> Map.get(:footer) == "Author: W3NDO"
      end)
  end
end
