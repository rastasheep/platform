defmodule Platform.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :slug, :string
    field :contact_email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :contact_email])
    |> validate_required([:name, :contact_email])
    |> generate_slug()
    |> unique_constraint(:slug)
    |> validate_format(:contact_email, ~r/@/)
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
