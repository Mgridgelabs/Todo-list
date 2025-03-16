defmodule TodoAppWeb.TodoAppWeb.PageLive do
  use TodoAppWeb, :live_view
  alias TodoApp.Todos

  @impl true
  def mount(_params, _session, socket) do
    items = Todos.list_items()
    {:ok, assign(socket, items: items, editing: %{id: 0, name: ""})}
  end

  @impl true
  def handle_event("create_item", %{"name" => name}, socket) do
    with {:ok, new_item} <- Todos.create_item(%{name: name, done: false}) do
      items = get_items(socket)
      items = [new_item | items]

      {:noreply, assign(socket, items: items)}
    end
  end

  def handle_event("delete_item", %{"id" => id}, socket) do
    items = get_items(socket)
    item = get_item_by_id(items, id)

    with {:ok, deleted_item} <- Todos.delete_item(item) do
      items = Enum.filter(items, fn item -> item.id != deleted_item.id end)
      {:noreply, assign(socket, items: items)}
    end
  end

  def handle_event("update_editing", %{"id" => id}, socket) do
    items = get_items(socket)
    editing = get_item_by_id(items, id)
    {:noreply, assign(socket, :editing, editing)}
  end

  def handle_event("update_item_name", %{"id" => id, "name" => name}, socket) do
    items = get_items(socket)
    item = get_item_by_id(items, id)

    with {:ok, updated_item} <- Todos.update_item(item, %{name: name}) do
      items = update_item(items, updated_item)
      {:noreply, assign(socket, items: items, editing: updated_item)}
    end
  end

  def handle_event("toggle_item", %{"id" => id}, socket) do
    items = get_items(socket)
    item = get_item_by_id(items, id)

    with {:ok, updated_item} <- Todos.update_item(item, %{done: !item.done}) do
      items = update_item(items, updated_item)
      {:noreply, assign(socket, items: items)}
    end
  end

  defp get_item_by_id(items, id) do
    Enum.find(items, fn item -> item.id == String.to_integer(id) end)
  end

  defp update_item(items, new_item) do
    Enum.map(items, fn item ->
      if item.id == new_item.id do
        new_item
      else
        item
      end
    end)
  end

  defp get_items(socket) do
    socket.assigns.items
  end
end
