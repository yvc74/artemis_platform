defmodule AtlasWeb.UserImpersonationController do
  use AtlasWeb, :controller

  import AtlasWeb.Guardian.Plug

  alias Atlas.Event
  alias Atlas.GetUser
  alias AtlasWeb.CreateSession

  def create(conn, %{"user_id" => id}) do
    authorize(conn, "user-impersonations:create", fn () ->
      user = GetUser.call!(id, current_user(conn))

      with {:ok, _} <- CreateSession.call(user),
           {:ok, _} <- Event.broadcast(user, "user-impersonation:created", current_user(conn)) do
        conn
        |> sign_in(user)
        |> put_flash(:info, "User impersonation created")
        |> redirect(to: "/")
      else
        {:error, _} ->
          conn
          |> put_flash(:error, "Error creating user impersonation")
          |> redirect(to: Routes.user_path(conn, :show, user))
      end
    end)
  end
end
