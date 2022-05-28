defmodule HoprWeb.RoomController do
  use HoprWeb, :controller

  alias Hopr.Channel
  alias Hopr.Channel.Room

  action_fallback HoprWeb.FallbackController

  def index(conn, _params) do
    name = Channel.list_rooms()
    render(conn, "index.json", name: name)
  end

  def create(conn, %{"room" => room_params}) do
    case room_params do
      %{"name" => name, "apiKey" => apiKey} ->
        case Channel.create_room(name, apiKey) do
          {:ok, room} ->
            IO.inspect room
            temp = %{id: room.id, name: room.name, auth_key: room.auth_key}
            IO.inspect temp
            render(conn, "new.json", room: temp)
          {:error, err} ->
            conn
            |> send_resp(500, err)
        end
        _ -> send_resp(conn, 403, "invalid params")
      end
  end

  def show(conn, %{"id" => id}) do
    room = Channel.get_room!(id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Channel.get_room!(id)

    with {:ok, %Room{} = room} <- Channel.update_room(room, room_params) do
      render(conn, "show.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Channel.get_room!(id)

    with {:ok, %Room{}} <- Channel.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
