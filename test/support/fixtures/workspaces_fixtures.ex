defmodule Platform.WorkspacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Platform.Workspaces` context.
  """

  @doc """
  Generate a workspace.
  """
  def workspace_fixture(attrs \\ %{}) do
    {:ok, workspace} =
      attrs
      |> Enum.into(%{
        name: "Workspace name",
        slug: "workspace-name",
        description: "Workspace description"
      })
      |> Platform.Workspaces.create_workspace()

    workspace
  end
end
