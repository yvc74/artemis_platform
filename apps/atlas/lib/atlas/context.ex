defmodule Atlas.Context do
  defmodule Error do
    defexception message: "Context Error"
  end

  defmacro __using__(_opts) do
    quote do
      import Atlas.Context
      import Atlas.Repo.Helpers
      import Atlas.UserAccess

      alias Atlas.Event
    end
  end
end
