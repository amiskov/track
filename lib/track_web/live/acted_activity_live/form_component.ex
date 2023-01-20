defmodule TrackWeb.ActedActivityLive.FormComponent do
  use TrackWeb, :live_component

  alias Track.Activities

  @impl true
  def update(%{acted_activity: acted_activity} = assigns, socket) do
    changeset = Activities.change_acted_activity(acted_activity)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"acted_activity" => acted_activity_params}, socket) do
    changeset =
      socket.assigns.acted_activity
      |> Activities.change_acted_activity(acted_activity_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"acted_activity" => acted_activity_params}, socket) do
    save_acted_activity(socket, socket.assigns.action, acted_activity_params)
  end

  defp save_acted_activity(socket, :edit, acted_activity_params) do
    case Activities.update_acted_activity(socket.assigns.acted_activity, acted_activity_params) do
      {:ok, _acted_activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Acted activity updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_acted_activity(socket, :new, acted_activity_params) do
    case Activities.create_acted_activity(acted_activity_params) do
      {:ok, _acted_activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Acted activity created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
