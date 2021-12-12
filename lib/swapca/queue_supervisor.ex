defmodule Swapca.QueueSupervisor do
  use DynamicSupervisor

  @me QueueSupervisor

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  def queue_up(msg_data) do
    send_after = Application.get_env(:swapca, :send_after)
    DynamicSupervisor.start_child(@me, {Swapca.QueueItem, [msg_data, send_after]})
  end
end
