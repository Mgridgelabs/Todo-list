defmodule TodoAppWeb.PageLive do
  use TodoAppWeb, :live_view
  alias TodoApp.Todos


  def mount(_params, _session, socket) do
    items = Todos.list_items()
    {:ok, assign(socket, items: items)}
  end

  def handle_event("create_item", %{"name" => name}, socket) do
    {:ok, item} = Todos.create_item(%{name: name, completed: false})
    {:noreply, assign(socket, items: Todos.list_items())}
  end


end
