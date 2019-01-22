defmodule PhoenixSpiWeb.BufferController do
  use PhoenixSpiWeb, :controller

  def index(conn, _params) do
    buffers = PhoenixSpi.Buffer |> PhoenixSpi.Repo.all
    render(conn, "index.html", buffers: buffers)
  end

  def new(conn, params) do
    changeset = PhoenixSpi.Buffer.changeset(%PhoenixSpi.Buffer{}, %{name: Ecto.UUID.generate})

    {:ok, buffer} = PhoenixSpi.Repo.insert(changeset)

    conn
    |> put_status(302)
    |> redirect(to: buffer_path(conn, :show, buffer.name))
  end

  def show(conn,  %{"id" => id}) do
    render(conn, "show.html", buffer: PhoenixSpi.Repo.get_by(PhoenixSpi.Buffer, %{name: id}))
  end
end
