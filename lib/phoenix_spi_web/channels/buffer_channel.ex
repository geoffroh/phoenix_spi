defmodule PhoenixSpiWeb.BufferChannel do
  use Phoenix.Channel
  def join("buffer:" <> private_room_id, _params, socket) do
    :ets.insert(:buffers, {"current", private_room_id})
    {:ok, socket}
  end

  def handle_in("buffer", buffer, socket) do
    spawn(__MODULE__, :send_buffer_to_spi, [buffer])
    spawn(__MODULE__, :save_buffer, [buffer])
    broadcast! socket, "buffer", buffer
    {:noreply, socket}
  end

  def handle_in("stop_buffer", _buffer, socket) do
    {:ok, x} = OSC.encode(%OSC.Message{address: "/stop-all-jobs", arguments: ["PheonixSpi"]})
    server = Socket.UDP.open!
    Socket.Datagram.send!(server, x, {{127,0,0,1}, 4557})
    {:noreply, socket}
  end

  def send_buffer_to_spi(%{"buffer" => buffer}) do
    {:ok, x} = OSC.encode(%OSC.Message{address: "/run-code", arguments: ["PheonixSpi", buffer]})
    server = Socket.UDP.open!
    Socket.Datagram.send!(server, x, {{127,0,0,1}, 4557})
  end

  def save_buffer(%{"id" => id, "buffer" => buffer}) do
    PhoenixSpi.Repo.get_by(PhoenixSpi.Buffer, %{name: id})
    |> PhoenixSpi.Buffer.changeset(%{content: buffer})
    |> PhoenixSpi.Repo.update!
  end
end
