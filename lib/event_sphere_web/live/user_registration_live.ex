defmodule EventSphereWeb.UserRegistrationLive do
  use EventSphereWeb, :live_view

  alias EventSphere.Accounts
  alias EventSphere.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="relative min-h-screen flex items-center justify-center overflow-hidden">
      <!-- Background Video -->
      <video autoplay muted loop playsinline class="absolute inset-0 w-full h-full object-cover z-0">
        <source src="/videos/bg.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </video>

      <!-- SPATO Registration Card -->
      <div class="relative z-10 bg-white rounded-lg shadow-md p-8 w-full max-w-sm">
        <!-- Logo + Title -->
        <div class="flex items-center justify-center mb-6 text-center">
          <img src={~p"/images/logo-6.png"} alt="SPATO Logo" class="w-76 h-34 mr-4">
        </div>

        <!-- Registration Header -->
        <h2 class="text-lg font-semibold text-center text-[#224179] mb-2">
          Daftar Akaun Pengguna
        </h2>
        <p class="text-sm text-center text-gray-600 mb-6">
          Sudah mempunyai akaun?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-[#224179] hover:underline">
            Log masuk
          </.link>
        </p>

        <!-- Registration Form -->
        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Kata Laluan" required />

          <:actions>
            <.button phx-disable-with="Mendaftarkan..." class="w-full bg-[#224179] hover:bg-[#19345c] text-white font-semibold py-2 rounded-md">
              Daftar Akaun
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Map.put(user_params, "role", "user")

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
