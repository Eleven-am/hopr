defmodule HoprWeb.RoomView do
  use HoprWeb, :view
  alias HoprWeb.RoomView

  def render("index.json", %{name: name}) do
    %{data: render_many(name, RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
    }
  end

  def render("new.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      auth_key: room.auth_key,
    }
  end
end
