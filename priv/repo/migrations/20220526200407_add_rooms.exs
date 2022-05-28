defmodule Hopr.Repo.Migrations.AddRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :auth_key, :string, null: false
      add :user_id, references("users", on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:rooms, [:auth_key])
  end
end
