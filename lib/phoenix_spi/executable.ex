defmodule PhoenixSpi.Executable do
  use GenServer

  def start_link(executable, args) do
    GenServer.start_link(__MODULE__, [executable, [args]])
  end

  def init([executable, args]) do
    start_ets(executable)
    port = Port.open({:spawn_executable, executable}, [:binary, args: args])
    {:ok, port}
  end

  def start_ets("/usr/local/bin/oscdump"), do: :nil
  def start_ets(_executable) do
    :ets.new(:buffers, [:named_table, :public])
    :ets.insert(:buffers, {"current", ""})
  end

  def handle_info({port, {_data, info}}, x) do
    [{"current", current_buffer}] = :ets.lookup(:buffers, "current")
    broadcast_log_info(current_buffer, info)
    {:noreply, x}
  end

  def broadcast_log_info(nil, _info), do: nil
  def broadcast_log_info("", _info), do: nil
  def broadcast_log_info(current_buffer, info) do
    PhoenixSpiWeb.Endpoint.broadcast!("buffer:#{current_buffer}", "log", %{log: info})
  end
end
