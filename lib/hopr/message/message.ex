defmodule Hopr.Message.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :map
    field :recipient, :string
    field :sender, :string
    belongs_to :room, Hopr.Channel.Room
    belongs_to :user, Hopr.Account.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:sender, :recipient, :content, :room_id, :user_id])
    |> validate_required([:sender, :recipient, :content, :room_id, :user_id])
  end
end
