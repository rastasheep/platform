defmodule Platform.Workspaces.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workspaces" do
    field :name, :string
    field :slug, :string
    field :description, :string

    belongs_to :organization, Platform.Accounts.Organization

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :description, :organization_id])
    |> validate_required([:name, :organization_id])
    |> generate_slug()
    |> unique_constraint([:slug, :organization_id], error_key: :name)
  end

  defp generate_slug(changeset) do
    case fetch_change(changeset, :name) do
      {:ok, title} -> put_change(changeset, :slug, slugify(title))
      :error -> changeset
    end
  end

  def slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end

  defimpl Phoenix.Param do
    def to_param(%{slug: slug}), do: slug
  end
end
