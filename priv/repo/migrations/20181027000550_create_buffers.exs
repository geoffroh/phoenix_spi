defmodule PhoenixSpi.Repo.Migrations.CreateBuffers do
  use Ecto.Migration

  def change do
    create table(:buffers) do
      add :name, :string

      timestamps()
    end

  end
end
