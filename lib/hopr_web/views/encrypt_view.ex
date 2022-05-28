defmodule HoprWeb.EncryptView do
  use HoprWeb, :view
  alias HoprWeb.EncryptView

  def render("index.json", %{tokens: tokens}) do
    %{data: render_many(tokens, EncryptView, "encrypt.json")}
  end

  def render("show.json", %{encrypt: encrypt}) do
    %{data: render_one(encrypt, EncryptView, "encrypt.json")}
  end

  def render("encrypt.json", %{encrypt: encrypt}) do
    %{
      expires: encrypt.expires_in,
      token: encrypt.token
    }
  end
end
