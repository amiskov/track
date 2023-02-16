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
    |> assign(:new_acted_activity_params, nil)
    |> assign_activities_list()
  end

  defp apply_action(socket, :new, params) do
    params =
      params
      |> Map.put("begin_timestamp", get_latest_timestamp())
      |> Map.put("end_timestamp", NaiveDateTime.utc_now())

    socket
    |> assign(:page_title, "New Acted activity")
    |> assign_activities_list()
    |> assign(:acted_activity, %ActedActivity{})
    |> assign(:new_acted_activity_params, params)
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

  @doc "Immediately save new acted activity (on button click)."
  @impl true
  def handle_event("save", %{"acted-activity-id" => id}, socket) do
    params = %{
      activity_id: id,
      begin_timestamp: get_latest_timestamp(),
      end_timestamp: NaiveDateTime.utc_now()
    }

    case Activities.create_acted_activity(params) do
      {:ok, _acted_activity} ->
        {:noreply,
         socket
         |> put_flash(:info, "Acted activity created successfully")
         |> push_redirect(to: "/")}
    end
  end

  defp list_acted_activities do
    tz = Application.get_env(:track, :default_timezone)
    now = Timex.now(tz)

    Activities.list_acted_activities_for_date(now)
    |> Enum.map(fn a ->
      duration =
        Timex.diff(a.end_timestamp, a.begin_timestamp, :second)
        |> Timex.Duration.from_seconds()
        |> Timex.Format.Duration.Formatters.Humanized.format()

      # TODO: Do everything with Timex.

      {:ok, end_time} = DateTime.shift_zone(a.end_timestamp, tz)
      end_time = DateTime.to_time(end_time)

      {:ok, begin_time} = DateTime.shift_zone(a.begin_timestamp, tz)
      begin_time = DateTime.to_time(begin_time)

      a
      |> Map.put(:duration, duration)
      |> Map.put(:time_span, "#{begin_time}—#{end_time}")
    end)
  end

  defp assign_activities_list(socket) do
    activities_list =
      Activities.list_activities()
      |> Enum.map(fn a ->
        %{
          title: a.title,
          id: a.id,
          type: a.activity_type
        }
      end)

    assign(socket, :activities_list, activities_list)
  end

  defp get_latest_timestamp do
    case Activities.get_last_acted_activity_end_timestamp!() do
      nil -> NaiveDateTime.utc_now()
      end_timestamp -> end_timestamp
    end
  end
end
