defmodule Hopr.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hopr.Messages` context.
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
      |> Hopr.Messages.create_message()

    message
  end
end
