defmodule Platform.WorkspacesTest do
  use Platform.DataCase

  alias Platform.Workspaces

  describe "workspaces" do
    setup [:create_organization]

    alias Platform.Workspaces.Workspace

    import Platform.WorkspacesFixtures
    import Platform.AccountsFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_workspaces/0 returns all workspaces", %{organization: organization} do
      workspace = workspace_fixture(organization_id: organization.id)
      assert Workspaces.list_workspaces() == [workspace]
    end

    test "get_workspace!/1 returns the workspace with given id", %{organization: organization} do
      workspace = workspace_fixture(organization_id: organization.id)
      assert Workspaces.get_workspace!(workspace.slug) == workspace
    end

    test "create_workspace/1 with valid data creates a workspace" do
      valid_attrs = %{name: "some name", description: "some desc", organization_id: 1}

      assert {:ok, %Workspace{} = workspace} = Workspaces.create_workspace(valid_attrs)
      assert workspace.name == "some name"
      assert workspace.slug == "some-name"
      assert workspace.description == "some desc"
    end

    test "create_workspace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workspaces.create_workspace(@invalid_attrs)
    end

    test "update_workspace/2 with valid data updates the workspace", %{organization: organization} do
      workspace = workspace_fixture(organization_id: organization.id)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Workspace{} = workspace} =
               Workspaces.update_workspace(workspace, update_attrs)

      assert workspace.name == "some updated name"
      assert workspace.slug == "some-updated-name"
    end

    test "update_workspace/2 with invalid data returns error changeset", %{
      organization: organization
    } do
      workspace = workspace_fixture(organization_id: organization.id)
      assert {:error, %Ecto.Changeset{}} = Workspaces.update_workspace(workspace, @invalid_attrs)
      assert workspace == Workspaces.get_workspace!(workspace.slug)
    end

    test "delete_workspace/1 deletes the workspace", %{organization: organization} do
      workspace = workspace_fixture(organization_id: organization.id)
      assert {:ok, %Workspace{}} = Workspaces.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Workspaces.get_workspace!(workspace.slug) end
    end

    test "change_workspace/1 returns a workspace changeset", %{organization: organization} do
      workspace = workspace_fixture(organization_id: organization.id)
      assert %Ecto.Changeset{} = Workspaces.change_workspace(workspace)
    end

    defp create_organization(_) do
      organization = organization_fixture()
      %{organization: organization}
    end
  end
end
