defmodule PhoenixSpi.Buffer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buffers" do
    field :name, :string

    timestamps()
  end

  @required_fields ~w()
  @optional_fields ~w(name)

  @doc false
  def changeset(buffer, attrs) do
    buffer
    |> Map.merge(%{name: Ecto.UUID.generate})
    |> cast(attrs, @required_fields, @optional_fields)
  end
end
