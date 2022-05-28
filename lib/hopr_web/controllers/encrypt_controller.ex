defmodule HoprWeb.EncryptController do
  use HoprWeb, :controller

  alias Hopr.Account

  action_fallback HoprWeb.FallbackController

  def show(conn, %{"id" => key}) do
    case Account.generate_token!(key) do
      {:error, message} ->
        send_resp(conn, 403, message)
      {:ok, token} ->
        render(conn, "encrypt.json", encrypt: token)
    end
  end

end
