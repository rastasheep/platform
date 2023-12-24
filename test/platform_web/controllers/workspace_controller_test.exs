defmodule PlatformWeb.WorkspaceControllerTest do
  use PlatformWeb.ConnCase

  import Platform.WorkspacesFixtures
  import Platform.AccountsFixtures

  @create_attrs %{name: "some name", description: "description", organization_id: 1}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, slug: nil}

  describe "index" do
    test "lists all workspaces", %{conn: conn} do
      conn = get(conn, ~p"/workspaces")
      assert html_response(conn, 200) =~ "Listing Workspaces"
    end
  end

  describe "new workspace" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/workspaces/new")
      assert html_response(conn, 200) =~ "New Workspace"
    end
  end

  describe "create workspace" do
    test "redirects to show when data is valid", %{conn: conn} do
      organization = organization_fixture()

      conn =
        post(conn, ~p"/workspaces",
          workspace: Map.put(@create_attrs, :organization_id, organization.id)
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/workspaces/#{id}"

      conn = get(conn, ~p"/workspaces/#{id}")
      assert html_response(conn, 200) =~ id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/workspaces", workspace: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Workspace"
    end
  end

  describe "edit workspace" do
    setup [:create_workspace]

    test "renders form for editing chosen workspace", %{conn: conn, workspace: workspace} do
      conn = get(conn, ~p"/workspaces/#{workspace}/edit")
      assert html_response(conn, 200) =~ "Edit Workspace"
    end
  end

  describe "update workspace" do
    setup [:create_workspace]

    test "redirects when data is valid", %{conn: conn, workspace: workspace} do
      conn = put(conn, ~p"/workspaces/#{workspace}", workspace: @update_attrs)
      updated_workspace = Platform.Repo.reload(workspace)

      assert redirected_to(conn) == ~p"/workspaces/#{updated_workspace}"

      conn = get(conn, ~p"/workspaces/#{updated_workspace}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, workspace: workspace} do
      conn = put(conn, ~p"/workspaces/#{workspace}", workspace: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Workspace"
    end
  end

  describe "delete workspace" do
    setup [:create_workspace]

    test "deletes chosen workspace", %{conn: conn, workspace: workspace} do
      conn = delete(conn, ~p"/workspaces/#{workspace}")
      assert redirected_to(conn) == ~p"/workspaces"

      assert_error_sent 404, fn ->
        get(conn, ~p"/workspaces/#{workspace}")
      end
    end
  end

  defp create_workspace(_) do
    organization = organization_fixture()
    workspace = workspace_fixture(organization_id: organization.id)
    %{workspace: workspace}
  end
end
