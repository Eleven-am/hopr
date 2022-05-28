defmodule Hopr.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hopr.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        confirmation_token: "some confirmation_token",
        email: "some email",
        is_confirmed: true,
        password: "some password",
        user_token: "some user_token",
        username: "some username"
      })
      |> Hopr.Account.create_user()

    user
  end
end
