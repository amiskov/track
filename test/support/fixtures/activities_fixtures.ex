defmodule Track.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Track.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "Some Necessary Activity",
        activity_type: "necessary"
      })
      |> Track.Activities.create_activity()

    activity
  end

  @doc """
  Generate a acted_activity.
  """
  def acted_activity_fixture(attrs \\ %{}) do
    {:ok, acted_activity} =
      attrs
      |> Enum.into(%{
        begin_timestamp: ~N[2023-01-19 12:23:00],
        end_timestamp: ~N[2023-01-19 12:23:00]
      })
      |> Track.Activities.create_acted_activity()

    acted_activity
  end
end
