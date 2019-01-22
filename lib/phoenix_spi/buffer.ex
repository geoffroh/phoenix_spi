defmodule PhoenixSpi.Buffer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buffers" do
    field :name, :string
    field :content, :string

    timestamps()
  end

  @required_fields ~w()
  @optional_fields ~w(name content)

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, @optional_fields, @required_fields)
  end
end
