defmodule Hopr.Repo.Migrations.AddMessageIndex do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX message_content ON messages USING GIN(content)")
  end

  def down do
    execute("DROP INDEX message_content")
  end
end
