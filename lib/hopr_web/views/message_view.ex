defmodule HoprWeb.MessageView do
  use HoprWeb, :view
  alias HoprWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      sender: message.sender,
      recipient: message.recipient,
      content: message.content
    }
  end
end
