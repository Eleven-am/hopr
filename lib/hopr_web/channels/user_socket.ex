defmodule HoprWeb.UserSocket do
  use Phoenix.Socket
  alias Hopr.Account
  alias HoprWeb.UserTracker

  channel "scribed:*", HoprWeb.ScribeChannel
  channel "open:*", HoprWeb.RoomChannel

  def connect(params, socket, _connect_info) do
    case verify_token(params) do
      {:ok, user} ->
        case count_api_channel(user) do
          {:ok, _} ->
            {:ok, assign(socket, :user, user)}
          {:error, reason} ->
            {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  def id(socket), do: "users_socket:#{socket.assigns.user.api_key}"

  defp verify_token(token) do
    case Account.retrieve_user!(token) do
      {:error, reason} ->
        {:error, reason}
      {:ok, user} ->
        if user.is_confirmed do
          {:ok, user}
        else
          {:error, "User not confirmed"}
        end
    end
  end

  defp count_api_channel(user) do
    lists = UserTracker.list("api_connections:#{user.api_key}")
    number_of_presences = length(lists)
    case user.role do
      :admin ->
        {:ok, "valid connection"}
      :slim ->
        if number_of_presences > 5 do
          {:error, "Too many connections"}
        else
          {:ok, "valid connection"}
        end
      :medium ->
        if number_of_presences > 10 do
          {:error, "Too many connections"}
        else
          {:ok, "valid connection"}
        end
      :full ->
        if number_of_presences > 15 do
          {:error, "Too many connections"}
        else
          {:ok, "valid connection"}
        end
    end
  end
end
