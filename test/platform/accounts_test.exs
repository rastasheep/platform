defmodule Platform.AccountsTest do
  use Platform.DataCase

  alias Platform.Accounts

  describe "organizations" do
    alias Platform.Accounts.Organization

    import Platform.AccountsFixtures

    @invalid_attrs %{name: nil, slug: nil, contact_email: nil}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Accounts.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given slug" do
      organization = organization_fixture()
      assert Accounts.get_organization!(organization.slug) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{name: "some name", contact_email: "contact@email.com"}

      assert {:ok, %Organization{} = organization} = Accounts.create_organization(valid_attrs)
      assert organization.name == "some name"
      assert organization.slug == "some-name"
      assert organization.contact_email == "contact@email.com"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()

      update_attrs = %{
        name: "some updated name",
        contact_email: "contact2@email.com"
      }

      assert {:ok, %Organization{} = organization} =
               Accounts.update_organization(organization, update_attrs)

      assert organization.name == "some updated name"
      assert organization.slug == "some-updated-name"
      assert organization.contact_email == "contact2@email.com"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_organization(organization, @invalid_attrs)

      assert organization == Accounts.get_organization!(organization.slug)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organization!(organization.slug) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end
end
