defmodule EventSphereWeb.AdminDashboardLive do
  use EventSphereWeb, :live_view

  on_mount {EventSphereWeb.UserAuth, :ensure_authenticated}

  def mount(_params, _session, socket) do
    if socket.assigns.current_user.role != "admin" do
      {:halt,
        socket
        |> put_flash(:error, "Access denied")
        |> redirect(to: "/dashboard")}
    else
      {:ok, assign(socket, :page_title, "Admin Dashboard")}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-3xl font-bold">Welcome, Admin!</h1>
      <p class="mt-4">This is your dashboard.</p>
    </div>
    """
  end
end
