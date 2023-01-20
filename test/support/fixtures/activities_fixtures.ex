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
end
