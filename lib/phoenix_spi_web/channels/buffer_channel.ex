defmodule PhoenixSpiWeb.BufferChannel do
  use Phoenix.Channel
  def join("buffer:" <> _private_room_id, _params, _socket) do
    {:ok, _socket}
  end

  def handle_in("buffer", buffer, socket) do
    spawn(__MODULE__, :send_buffer_to_spi, [buffer])
    broadcast! socket, "buffer", buffer
    {:noreply, socket}
  end

  def send_buffer_to_spi(%{"buffer" => buffer}) do
    IO.inspect(buffer)
    {:ok, x} = OSC.encode(%OSC.Message{address: "/run-code", arguments: ["PheonixSpi", buffer]})
    IO.inspect(x)
    server = Socket.UDP.open!
    resp = Socket.Datagram.send!(server, x, {{127,0,0,1}, 4557})
    IO.inspect(resp)
  end
end
