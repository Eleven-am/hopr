defmodule Hopr.Repo.Migrations.AddUser do
  use Ecto.Migration
  alias Hopr.Account.UserRole

  def change do
    UserRole.create_type()

    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false
      add :api_key, :string, null: false
      add :user_token, :string, null: false
      add :confirmation_token, :string, null: false
      add :is_confirmed, :boolean, default: false, null: false
      add :role, :user_role, default: "slim", null: false

      timestamps()
    end
  end
end
