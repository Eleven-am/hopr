defmodule Hopr.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias Hopr.Repo

  alias Hopr.Account.User
  alias Hopr.Encrypt.Encrypt

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by apiKey.

  Returns `nil` if the User does not exist.

  ## Examples

      iex> get_user_by_apiKey(123)
      %User{}

      iex> get_user_by_apiKey(456)
      nil

  """
  def get_user_by_apiKey(apiKey), do: Repo.get_by(User, api_key: apiKey)

  @doc """
  Gets a single user.

  Raises if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %Room{}

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Retrieves a single user by decrypting the token used to connect.

  ## Examples

      iex> retrieve_user!(%{user_token: token})
      iex> retrieve_user!(%{apu_key: token})
      %User{} | {error: reason}

  """
  def retrieve_user!(params) do
    case params do
      %{"user_token" => token} ->
        date = :os.system_time(:millisecond)
        case Encrypt.decrypt(token) do
          {:ok, %{"user_token" => user_token, "date" =>  time}} ->
            if date - time > 1000 * 60 * 60 * 24 * 7 do
              {:error, "Token expired"}
            else
              case Repo.get_by(User, user_token: user_token) do
                nil -> {:error, "User not found"}
                user -> {:ok, user}
              end
            end
          _ -> {:error, "Invalid token"}
        end
        %{"apiKey" => token} ->
          case Repo.get_by(User, api_key: token) do
            nil -> {:error, "User not found"}
            user -> {:ok, user}
          end
        _ -> {:error, "Invalid token provided"}
    end
  end

  @doc """
  Gets a single user by api_key.
  Generates a new token if the user exists.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def generate_token!(api_key) do
    case Repo.get_by(User, api_key: api_key) do
      nil ->
        {:error, "Invalid api_key"}
      %User{user_token: user_token} ->
        date = :os.system_time(:millisecond)
        user_token = user_token
        sevenDays = 1000 * 60 * 60 * 24 * 7
        token = Encrypt.encrypt(%{user_token: user_token, date: date})
        {:ok, %{expires_in: (date + sevenDays), token: token}}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    temp = %{
      "user_token" => Encrypt.generateKey(5, 16),
      "api_key" => Encrypt.generateKey(5, 5),
      "role" => "slim",
      "confirmation_token" => Encrypt.generateUUID(),
    }
    attrs = Map.merge(temp, attrs)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
