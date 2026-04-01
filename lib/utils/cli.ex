defmodule Utils.Cli do

  @steps [
    init,
    get_scope,
    get_description,
    get_body,
    get_footer,
    confirm_details,
    write_and_commit
  ]

  def run_repl(%{type: type, body: body, footer: footer} = opts, [current_step, next_step] = steps) do
  end


  def step(opts, [current, next_step | other]) do
    step_res = nil
  end



  defp get_scope(opts) do
    prompt = case Map.get(opts, :scoped, false) do
      true ->
        get_input("Enter the scope of your commit: ")
      false ->
        switch
    end
  end

  defp switch_user_input?(prompt) do
    response = IO.gets(prompt) |> String.trim() |> String.downcase()
    case Enum.member?(~w(yes no y n), response) do
      false ->
        switch_user_input(prompt <> "(yes/y/no/n)")
      _ ->
        cond do
          response in ~w(yes y) ->
            true
          response in ~w(no n) ->
            false
        end
    end
  end

  defp get_input(prompt) do
    IO.ANSI.color(" #CBC3E3")
    input = IO.gets(prompt <> "\n") |> String.trim
    input
  end
end
