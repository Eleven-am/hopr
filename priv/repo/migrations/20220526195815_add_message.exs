defmodule Hopr.Repo.Migrations.AddMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender, :string, null: false
      add :recipient, :string, null: false
      add :content, :map, default: %{}
      add :user_id, references("users", on_delete: :delete_all)

      timestamps()
    end
  end
end
