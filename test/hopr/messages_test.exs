defmodule Hopr.MessagesTest do
  use Hopr.DataCase

  alias Hopr.Messages

  describe "messages" do
    alias Hopr.Messages.Message

    import Hopr.MessagesFixtures

    @invalid_attrs %{content: nil, recipient: nil, sender: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: %{}, recipient: "some recipient", sender: "some sender"}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.content == %{}
      assert message.recipient == "some recipient"
      assert message.sender == "some sender"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: %{}, recipient: "some updated recipient", sender: "some updated sender"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.content == %{}
      assert message.recipient == "some updated recipient"
      assert message.sender == "some updated sender"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
