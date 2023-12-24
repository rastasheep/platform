defmodule Platform.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Platform.Accounts` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        contact_email: "contact@email.com",
        name: "Some name",
        slug: "some-name"
      })
      |> Platform.Accounts.create_organization()

    organization
  end
end
