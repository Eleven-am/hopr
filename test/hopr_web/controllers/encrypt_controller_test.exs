defmodule HoprWeb.EncryptControllerTest do
  use HoprWeb.ConnCase

  import Hopr.AuthFixtures

  alias Hopr.Auth.Encrypt

  @create_attrs %{
    token: "some token"
  }
  @update_attrs %{
    token: "some updated token"
  }
  @invalid_attrs %{token: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tokens", %{conn: conn} do
      conn = get(conn, Routes.encrypt_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create encrypt" do
    test "renders encrypt when data is valid", %{conn: conn} do
      conn = post(conn, Routes.encrypt_path(conn, :create), encrypt: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.encrypt_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "token" => "some token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.encrypt_path(conn, :create), encrypt: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update encrypt" do
    setup [:create_encrypt]

    test "renders encrypt when data is valid", %{conn: conn, encrypt: %Encrypt{id: id} = encrypt} do
      conn = put(conn, Routes.encrypt_path(conn, :update, encrypt), encrypt: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.encrypt_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "token" => "some updated token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, encrypt: encrypt} do
      conn = put(conn, Routes.encrypt_path(conn, :update, encrypt), encrypt: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete encrypt" do
    setup [:create_encrypt]

    test "deletes chosen encrypt", %{conn: conn, encrypt: encrypt} do
      conn = delete(conn, Routes.encrypt_path(conn, :delete, encrypt))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.encrypt_path(conn, :show, encrypt))
      end
    end
  end

  defp create_encrypt(_) do
    encrypt = encrypt_fixture()
    %{encrypt: encrypt}
  end
end
