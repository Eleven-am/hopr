defmodule Hopr.Channel.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :auth_key, :string
    field :name, :string
    has_many :messages, Hopr.Message.Message
    belongs_to :user, Hopr.Account.User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :auth_key, :user_id])
    |> validate_required([:name, :auth_key, :user_id])
  end
end
