defmodule Hopr.ChannelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hopr.Channel` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: %{},
        recipient: "some recipient",
        sender: "some sender"
      })
      |> Hopr.Channel.create_message()

    message
  end

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        auth_key: "some auth_key",
        roomd_id: "some roomd_id"
      })
      |> Hopr.Channel.create_room()

    room
  end

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        auth_key: "some auth_key",
        room_id: "some room_id"
      })
      |> Hopr.Channel.create_room()

    room
  end
end
