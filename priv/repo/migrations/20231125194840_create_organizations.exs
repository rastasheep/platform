defmodule Platform.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :slug, :string
      add :contact_email, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:organizations, [:slug])
  end
end
