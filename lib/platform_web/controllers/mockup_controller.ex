defmodule PlatformWeb.MockupController do
  use PlatformWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
