defmodule PlatformWeb.MockupHTML do
  use PlatformWeb, :html

  embed_templates "mockup_html/*"

  @doc """
  Renders a popup menu that shows up on toggle click.

  ## Examples

      <.menu id="my-menu">
        <:toggle>
          <button>Open</button>
        </:toggle>
        <.menu_item>
          <button role="menuitem">Option 1</button>
        </.menu_item>
        <.menu_item>
          <button role="menuitem">Option 2</button>
        </.menu_item>
      </.menu>

  """
  attr :id, :string, required: true
  attr :disabled, :boolean, default: false, doc: "whether the menu is active"

  attr :position, :atom,
    default: :bottom_right,
    values: [:top_left, :top_right, :bottom_left, :bottom_right]

  slot :toggle, required: true

  slot :inner_block, required: true

  def menu(assigns) do
    ~H"""
    <div class="relative" id={@id}>
      <div
        phx-click={not @disabled && show_menu(@id)}
        phx-window-keydown={hide_menu(@id)}
        phx-key="escape"
      >
        <%= render_slot(@toggle) %>
      </div>
      <div id={"#{@id}-overlay"} class="fixed z-[90] inset-0 hidden" phx-click-away={hide_menu(@id)}>
      </div>
      <menu
        id={"#{@id}-content"}
        class={[
          "absolute z-[100] rounded-lg bg-white flex flex-col py-2 shadow-2xl hidden",
          menu_position_class(@position)
        ]}
        role="menu"
        phx-click-away={hide_menu(@id)}
      >
        <%= render_slot(@inner_block) %>
      </menu>
    </div>
    """
  end

  @doc """
  Renders a menu item used in `menu/1`.
  """
  attr :disabled, :boolean, default: false

  slot :inner_block, required: true

  def menu_item(assigns) do
    ~H"""
    <li class={[
      "w-full",
      "[&>:first-child]:w-full [&>:first-child]:flex [&>:first-child]:space-x-3 [&>:first-child]:px-5 [&>:first-child]:py-2 [&>:first-child]:items-center [&>:first-child:hover]:bg-gray-100 [&>:first-child:focus]:bg-gray-100 [&>:first-child]:whitespace-nowrap font-medium",
      @disabled && "pointer-events-none opacity-50"
    ]}>
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  defp show_menu(id) do
    JS.show(to: "##{id}-overlay")
    |> JS.show(to: "##{id}-content", display: "flex")
  end

  defp hide_menu(id) do
    JS.hide(to: "##{id}-overlay")
    |> JS.hide(to: "##{id}-content")
  end

  defp menu_position_class(:top_left), do: "top-0 left-0 transform -translate-y-full -mt-4"
  defp menu_position_class(:top_right), do: "top-0 right-0 transform -translate-y-full -mt-4"
  defp menu_position_class(:bottom_left), do: "bottom-0 left-0 transform translate-y-full -mb-4"
  defp menu_position_class(:bottom_right), do: "bottom-0 right-0 transform translate-y-full -mb-4"
end
