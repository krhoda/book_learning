defmodule Todo.System do
  def start_link do
    Supervisor.start_link(
      [
        Todo.ProcessRegistry,
        Todo.Database,
        Todo.Cache
      ],
      strategy: :one_for_one
    )
  end

  # If it were a CB module:
  # use Supervisor
  # def start_link do
  #   Supervisor.start_link(__MODULE__, nil)
  # end

  # @impl Supervisor
  # def init(_) do
  #   Supervisor.init(
  #     [
  #       Todo.Database,
  #       Todo.Cache
  #     ],
  #     strategy: :one_for_one
  #   )
  # end
end
