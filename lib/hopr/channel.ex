defmodule Hopr.Channel do
  @moduledoc """
  The Channel context.
  """

  import Ecto.Query, warn: false
  alias Hopr.Repo
  alias Hopr.Channel.Room
  alias Hopr.Account
  alias Hopr.Encrypt.Encrypt

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.
  name: The name of the room.
  api_key: The api key for the user creating the room.

  ## Examples

      iex> create_room(name, api_key)
      {:ok, %Room{}}

      iex> create_room(name, api_key)
      {:error, ...}

  """
  def create_room(name, api_key) do
    auth_key = Encrypt.generateUUID()
    case Account.get_user_by_apiKey(api_key) do
      nil -> {:error, "Invalid api key"}
      %{role: role, id: user_id} ->
        size = Repo.aggregate(Room, :count, user_id: user_id)
        room = %{name: name, user_id: user_id, auth_key: auth_key}
        case role do
           :slim ->
             {:error, "Slim users cannot create rooms"}
           :admin ->
             %Room{}
             |> Room.changeset(room)
             |> Repo.insert()
           :medium ->
             if size > 5 do
               {:error, "Medium users cannot create more than 5 rooms"}
             else
               %Room{}
               |> Room.changeset(room)
               |> Repo.insert()
             end
           :full ->
             if size > 10 do
               {:error, "Full users cannot create more than 10 rooms"}
             else
               %Room{}
               |> Room.changeset(room)
               |> Repo.insert()
             end
         end
    end
  end

  @doc """
  Gets a single room by auth key.
  Raises if the Room does not exist. or if the user is not the owner of the room.
  auth_key: The auth key of the room.
  api_key: The api key of the user.

  ## Examples

      iex> get_room_by_auth_key(auth_key, api_key)
      {:ok, %Room{}}

      iex> get_room_by_auth_key(auth_key, api_key)
      {:error, ...}

  """
  def get_room_by_auth_key(auth_key, api_key) do
    case Account.get_user_by_apiKey(api_key) do
      nil -> {:error, "Invalid api key"}
      %{id: user_id} ->
        case Repo.get_by(Room, auth_key: auth_key) do
          nil -> {:error, "Room does not exist"}
          room ->
            if room.user_id == user_id do
              {:ok, room}
            else
              {:error, "You are not the owner of this room"}
            end
        end
    end
  end

  @doc """
  Updates a room.
  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, ...}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, ...}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns a data structure for tracking room changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
