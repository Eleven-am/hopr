defmodule Hopr.Repo.Migrations.AddMessageFkeys do
  use Ecto.Migration

  def change do
    alter table :messages do
      add :room_id, references("rooms", on_delete: :delete_all)
    end
  end
end
