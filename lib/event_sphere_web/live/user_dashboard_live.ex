defmodule EventSphereWeb.UserDashboardLive do
  use EventSphereWeb, :live_view

  @impl true
  def layout(_assigns), do: {EventSphereWeb.Layouts, :sidebar}
  on_mount {EventSphereWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "User Dashboard")}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-3xl font-bold">Welcome, <%= @current_user.email %>!</h1>
      <p class="mt-4">You're logged in as a <%= @current_user.role %>.</p>
    </div>
    """
  end
end
