defmodule PlatformWeb.WorkspaceHTML do
  use PlatformWeb, :html

  embed_templates "workspace_html/*"

  @doc """
  Renders a workspace form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def workspace_form(assigns)
end
