defmodule HoprWeb.ScribeChannel do
  use HoprWeb, :channel
  alias HoprWeb.UserTracker
  alias HoprWeb.Presence
  alias Hopr.Channel
  alias Hopr.Messages
  alias Hopr.Encrypt.Encrypt

  def join("scribed:"<>roomName, payload, socket) do
    case payload do
      %{"token" => auth_key, "username" => name} ->
        case Channel.get_room_by_auth_key(auth_key, socket.assigns.user.api_key) do
          {:ok, room} ->
            if room.name == roomName do
              reference = Encrypt.generateKey(1, 16)
              UserTracker.track_api_connections(socket.transport_pid, socket.assigns.user.api_key)
              HoprWeb.Endpoint.subscribe(reference)
              send(self(), :after_join)
              {:ok, assign(socket, name: name, reference: reference, room: room.name, room_id: room.id)}
            else
              {:error, "Room name does not match auth key"}
            end
          {:error, error} ->
            {:error, error}
        end
      _ ->
        {:error, "No auth key provided"}
    end
  end

  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.name, %{
        online_at: inspect(System.system_time(:second)),
        username: socket.assigns.name,
        reference: socket.assigns.reference,
        presenceState: "online"
      })

    messages = Messages.list_messages_from_room(socket.assigns.room_id)
    push(socket, "presence_state", Presence.list(socket))
    push(socket, "messages", %{messages: messages})
    push(socket, "inform", %{
      scribed: true,
      room: socket.assigns.room,
      username: socket.assigns.name,
      reference: socket.assigns.reference
    })
    {:noreply, socket}
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: _, event: _event, payload: payload}, socket) do
    push(socket, "whisper", payload)
    {:noreply, socket}
  end

  def handle_in("speak", payload, socket) do
    Messages.save_message(socket.assigns.user.id, socket.assigns.room_id, socket.assigns.name, payload)
    broadcast_from!(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("modPresenceState", %{"presenceState" => state}, socket) do
    Presence.update(socket, socket.assigns.name, %{
      online_at: inspect(System.system_time(:second)),
      username: socket.assigns.name,
      reference: socket.assigns.reference,
      presenceState: state
    })
    {:noreply, socket}
  end

  def handle_in("shout", payload, socket) do
    Messages.save_message(socket.assigns.user.id, socket.assigns.room_id, socket.assigns.name, payload)
    broadcast!(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("whisper", payload, socket) do
    case payload do
      %{"to" => reference, "message" => message} ->
        data = %{from: socket.assigns.reference, body: message, to: reference, username: socket.assigns.name}
        Messages.save_message(socket.assigns.user.id, socket.assigns.room_id, socket.assigns.name, payload, reference)
        HoprWeb.Endpoint.broadcast_from!(self(), reference, "whisper", data)
    end
    {:noreply, socket}
  end
end
