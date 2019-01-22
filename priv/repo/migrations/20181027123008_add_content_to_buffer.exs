defmodule PhoenixSpi.Repo.Migrations.AddContentToBuffer do
  use Ecto.Migration

  def change do
    alter table(:buffers) do
      add :content, :text
    end
  end
end
