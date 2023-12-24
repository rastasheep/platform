defmodule PlatformWeb.HomeLive.Home do
  use PlatformWeb, :live_view

  alias Platform.{Accounts, Workspaces}
  alias Platform.Accounts.Organization
  alias Platform.Workspaces.Workspace

  @impl true
  def mount(_params, _session, socket) do
    orgs = Accounts.list_organizations(preload: :workspaces)

    {:ok,
     assign(socket,
       organizations: orgs,
       filter: "",
       organization_changes: Accounts.change_organization(%Organization{}),
       workspace_changes: Workspaces.change_workspace(%Workspace{})
     )}
  end

  @impl true
  def handle_event("create-organization", %{"organization" => params}, socket) do
    case Accounts.create_organization(params, preload: :workspaces) do
      {:ok, org} ->
        socket
        |> update(:organizations, fn orgs -> [org | orgs] end)
        |> assign(organization_changes: Accounts.change_organization(%Organization{}))
        |> push_event("js-exec", %{to: "#org-modal", attr: "phx-remove"})
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:organization_changes, changeset)
        |> noreply()
    end
  end

  def handle_event("create-workspace", %{"workspace" => params}, socket) do
    case Workspaces.create_workspace(params) do
      {:ok, _workspace} ->
        socket
        |> update(:organizations, fn orgs -> Accounts.reload(orgs, preload: :workspaces) end)
        |> assign(workspace_changes: Workspaces.change_workspace(%Workspace{}))
        |> push_event("js-exec", %{to: "#workspace-modal", attr: "phx-remove"})
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:workspace_changes, changeset)
        |> noreply()
    end
  end

  defp org_options(organizations) do
    organizations
    |> Enum.sort_by(& &1.slug)
    |> Enum.map(fn org -> {org.name, org.id} end)
  end

  defp noreply(socket), do: {:noreply, socket}
end
