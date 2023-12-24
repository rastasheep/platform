defmodule PlatformWeb.WorkspaceController do
  use PlatformWeb, :controller

  alias Platform.Workspaces
  alias Platform.Workspaces.Workspace

  def index(conn, _params) do
    workspaces = Workspaces.list_workspaces()
    render(conn, :index, workspaces: workspaces)
  end

  def new(conn, _params) do
    changeset = Workspaces.change_workspace(%Workspace{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"workspace" => workspace_params}) do
    case Workspaces.create_workspace(workspace_params) do
      {:ok, workspace} ->
        conn
        |> put_flash(:info, "Workspace created successfully.")
        |> redirect(to: ~p"/workspaces/#{workspace}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => slug}) do
    workspace = Workspaces.get_workspace!(slug)
    render(conn, :show, workspace: workspace)
  end

  def edit(conn, %{"id" => slug}) do
    workspace = Workspaces.get_workspace!(slug)
    changeset = Workspaces.change_workspace(workspace)
    render(conn, :edit, workspace: workspace, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "workspace" => workspace_params}) do
    workspace = Workspaces.get_workspace!(slug)

    case Workspaces.update_workspace(workspace, workspace_params) do
      {:ok, workspace} ->
        conn
        |> put_flash(:info, "Workspace updated successfully.")
        |> redirect(to: ~p"/workspaces/#{workspace}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, workspace: workspace, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    workspace = Workspaces.get_workspace!(slug)
    {:ok, _workspace} = Workspaces.delete_workspace(workspace)

    conn
    |> put_flash(:info, "Workspace deleted successfully.")
    |> redirect(to: ~p"/workspaces")
  end
end
