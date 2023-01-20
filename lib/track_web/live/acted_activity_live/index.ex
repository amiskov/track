defmodule TrackWeb.ActedActivityLive.Index do
  use TrackWeb, :live_view

  alias Track.Activities
  alias Track.Activities.ActedActivity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :acted_activities, list_acted_activities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Acted activity")
    |> assign(:acted_activity, Activities.get_acted_activity!(id))
    |> assign_activities_list()
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Acted activity")
    |> assign_activities_list()
    |> assign(:acted_activity, %ActedActivity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Acted activities")
    |> assign_activities_list()
    |> assign(:acted_activity, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    acted_activity = Activities.get_acted_activity!(id)
    {:ok, _} = Activities.delete_acted_activity(acted_activity)

    {:noreply, assign(socket, :acted_activities, list_acted_activities())}
  end

  defp list_acted_activities do
    Activities.list_acted_activities()
  end

  defp assign_activities_list(socket) do
    activities_list = Activities.list_activities() |> Enum.map(fn a -> {a.title, a.id} end)

    assign(socket, :activities_list, activities_list)
  end
end
