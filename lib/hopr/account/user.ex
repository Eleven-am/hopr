defmodule Hopr.Account.UserRole do
  use EctoEnum, type: :user_role, enums: [:admin, :slim, :medium, :full]
end

defmodule Hopr.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hopr.Account.UserRole

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "users" do
    field :api_key, :string
    field :confirmation_token, :string
    field :email, :string
    field :is_confirmed, :boolean, default: false
    field :password, :string, redact: true
    field :user_token, :string
    field :username, :string
    field :role, UserRole
    has_many :rooms, Hopr.Channel.Room
    has_many :messages, Hopr.Message.Message

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :api_key, :user_token, :confirmation_token, :is_confirmed, :role])
    |> validate_required([:username, :email, :password, :api_key, :user_token, :confirmation_token, :is_confirmed, :role])
    |> unique_constraint(:username, message: "Username already taken")
    |> unique_constraint(:email, message: "An account with this email already exists")
    |> unique_constraint(:user_id)
    |> validate_format(:email, @mail_regex, message: "Invalid email format provided")
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number") # has a number
    |> validate_format(:password, ~r/[A-Z]+/, message: "Password must contain an upper-case letter") # has an upper case letter
    |> validate_format(:password, ~r/[a-z]+/, message: "Password must contain a lower-case letter") # has a lower case letter
    |> validate_format(:password, ~r/[#\!\-\?&@\$%^&*\(\)]+/, message: "Password must contain a symbol") # Has a symbol
    |> validate_confirmation(:password)
  end

end