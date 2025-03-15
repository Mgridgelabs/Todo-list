defmodule TodoApp.Todos.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :completed, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :completed])
    |> validate_required([:name, :completed])
  end
end
