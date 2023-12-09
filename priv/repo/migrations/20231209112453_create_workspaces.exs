defmodule Platform.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add :name, :string
      add :slug, :string
      add :description, :string
      add :organization_id, references(:organizations, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:workspaces, [:organization_id])
    create unique_index(:workspaces, [:slug])
  end
end
