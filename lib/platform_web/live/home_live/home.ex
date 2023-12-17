defmodule PlatformWeb.HomeLive.Home do
  use PlatformWeb, :live_view

  alias Platform.{Accounts, Workspaces}
  alias Platform.Accounts.Organization
  alias Platform.Workspaces.Workspace

  @impl true
  def mount(_params, _session, socket) do
    orgs = Accounts.list_organizations(preload: :workspaces)
    {:ok, assign(socket, orgs: orgs)}

    {:ok,
     assign(socket,
       orgs: orgs,
       filter: "",
       org_changes: Accounts.change_organization(%Organization{}),
       ws_changes: Workspaces.change_workspace(%Workspace{})
     )}
  end

  @impl true
  def handle_event("create-org", %{"organization" => params}, socket) do
    case Accounts.create_organization(params, preload: :workspaces) do
      {:ok, org} ->
        socket
        |> update(:orgs, fn orgs -> [org | orgs] end)
        |> assign(org_changes: Accounts.change_organization(%Organization{}))
        |> push_event("js-exec", %{to: "#org-modal", attr: "phx-remove"})
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:org_changes, changeset)
        |> noreply()
    end
  end

  def handle_event("create-ws", %{"workspace" => params}, socket) do
    case Workspaces.create_workspace(params) do
      {:ok, _workspace} ->
        socket
        |> update(:orgs, fn orgs -> Accounts.reload(orgs, preload: :workspaces) end)
        |> assign(ws_changes: Workspaces.change_workspace(%Workspace{}))
        |> push_event("js-exec", %{to: "#workspace-modal", attr: "phx-remove"})
        |> noreply()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> assign(:ws_changes, changeset)
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
