defmodule HoprWeb.UserView do
  use HoprWeb, :view
  alias HoprWeb.UserView

  def render("index.json", %{username: username}) do
    %{data: render_many(username, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username, email: user.email,
      role: user.role, is_confirmed: user.is_confirmed,
    }
  end

  def render("priv.json", %{user: user}) do
    %{
      id: user.id, apiKey: user.api_key,
      username: user.username, email: user.email,
      role: user.role, is_confirmed: user.is_confirmed,
    }
  end
end
