defmodule Hopr.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create index(:messages, [:room_id])
    create index(:messages, [:user_id])
  end
end
