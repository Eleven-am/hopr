defmodule Hopr.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Hopr.Repo

  alias Hopr.Message.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Returns the list of messages from a given room

  ## Examples

      iex> list_messages_from_room(room_id)
      [%Message{}, ...]

  """
  def list_messages_from_room(room_id) do
    query = from m in Message, where: m.room_id == ^room_id
    Repo.all(query)
    |> Enum.map(fn x -> convert_to_map x end)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Saves a message to the database.
  room_id is required.
  payload the message to save
  sender the sender of the message
  recipient the recipient of the message

  ## Examples

      iex> save_message(%Message{})
      %Message{}

  """
  def save_message(senderId, room_id, sender, payload, recipient \\ "@everyone") do
    %{
      room_id: room_id,
      content: payload,
      sender: sender,
      recipient: recipient,
      user_id: senderId
    }
    |> create_message()
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  defp convert_to_map(schema) do
    %{
      content: schema.content,
      sender: schema.sender,
      recipient: schema.recipient
    }
  end
end
