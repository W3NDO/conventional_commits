defmodule Utils.State do
  @moduledoc """
  Specifies the fields needed for state of a commit
  """
  defstruct type: nil,
            scope: nil,
            description: nil,
            body: nil,
            footer: nil,
            required_footer: false,
            required_body: false,
            scoped: false

  @type t() :: %__MODULE__{
          type: atom(),
          scope: String.t(),
          body: String.t(),
          description: String.t(),
          footer: String.t()
        }
end
