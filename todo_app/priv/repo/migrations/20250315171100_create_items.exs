defmodule TodoApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :completed, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
