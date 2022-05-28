defmodule Hopr.ChannelTest do
  use Hopr.DataCase

  alias Hopr.Channel

  describe "messages" do
    alias Hopr.Channel.Message

    import Hopr.ChannelFixtures

    @invalid_attrs %{content: nil, recipient: nil, sender: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Channel.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Channel.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: %{}, recipient: "some recipient", sender: "some sender"}

      assert {:ok, %Message{} = message} = Channel.create_message(valid_attrs)
      assert message.content == %{}
      assert message.recipient == "some recipient"
      assert message.sender == "some sender"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: %{}, recipient: "some updated recipient", sender: "some updated sender"}

      assert {:ok, %Message{} = message} = Channel.update_message(message, update_attrs)
      assert message.content == %{}
      assert message.recipient == "some updated recipient"
      assert message.sender == "some updated sender"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_message(message, @invalid_attrs)
      assert message == Channel.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Channel.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Channel.change_message(message)
    end
  end

  describe "room" do
    alias Hopr.Channel.Room

    import Hopr.ChannelFixtures

    @invalid_attrs %{auth_key: nil, roomd_id: nil}

    test "list_room/0 returns all room" do
      room = room_fixture()
      assert Channel.list_room() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Channel.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{auth_key: "some auth_key", roomd_id: "some roomd_id"}

      assert {:ok, %Room{} = room} = Channel.create_room(valid_attrs)
      assert room.auth_key == "some auth_key"
      assert room.roomd_id == "some roomd_id"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{auth_key: "some updated auth_key", roomd_id: "some updated roomd_id"}

      assert {:ok, %Room{} = room} = Channel.update_room(room, update_attrs)
      assert room.auth_key == "some updated auth_key"
      assert room.roomd_id == "some updated roomd_id"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_room(room, @invalid_attrs)
      assert room == Channel.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Channel.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Channel.change_room(room)
    end
  end

  describe "rooms" do
    alias Hopr.Channel.Room

    import Hopr.ChannelFixtures

    @invalid_attrs %{auth_key: nil, room_id: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Channel.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Channel.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{auth_key: "some auth_key", room_id: "some room_id"}

      assert {:ok, %Room{} = room} = Channel.create_room(valid_attrs)
      assert room.auth_key == "some auth_key"
      assert room.room_id == "some room_id"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{auth_key: "some updated auth_key", room_id: "some updated room_id"}

      assert {:ok, %Room{} = room} = Channel.update_room(room, update_attrs)
      assert room.auth_key == "some updated auth_key"
      assert room.room_id == "some updated room_id"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_room(room, @invalid_attrs)
      assert room == Channel.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Channel.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Channel.change_room(room)
    end
  end
end
