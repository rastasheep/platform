defmodule PlatformWeb.OrganizationController do
  use PlatformWeb, :controller

  alias Platform.Accounts
  alias Platform.Accounts.Organization

  def index(conn, _params) do
    organizations = Accounts.list_organizations()
    render(conn, :index, organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Accounts.change_organization(%Organization{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"organization" => organization_params}) do
    case Accounts.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => slug}) do
    organization = Accounts.get_organization!(slug)
    render(conn, :show, organization: organization)
  end

  def edit(conn, %{"id" => slug}) do
    organization = Accounts.get_organization!(slug)
    changeset = Accounts.change_organization(organization)
    render(conn, :edit, organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "organization" => organization_params}) do
    organization = Accounts.get_organization!(slug)

    case Accounts.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: ~p"/organizations/#{organization}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    organization = Accounts.get_organization!(slug)
    {:ok, _organization} = Accounts.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: ~p"/organizations")
  end
end
