defmodule Track.ActivitiesTest do
  use Track.DataCase

  alias Track.Activities

  describe "activities" do
    alias Track.Activities.Activity

    import Track.ActivitiesFixtures

    @invalid_attrs %{title: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates an activity" do
      valid_attrs = %{title: "some good activity", activity_type: "good"}

      assert {:ok, %Activity{} = activity} = Activities.create_activity(valid_attrs)
      assert activity.title == "some good activity"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "create_activity/1 with non-unique title returns error changeset" do
      activity = activity_fixture()
      {:error, changeset} = Activities.create_activity(%{title: activity.title})
      refute changeset.valid?
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end

  describe "acted_activities" do
    alias Track.Activities.ActedActivity

    import Track.ActivitiesFixtures

    @invalid_attrs %{begin_timestamp: nil, end_timestamp: nil}

    test "list_acted_activities/0 returns all acted_activities" do
      acted_activity = acted_activity_fixture()
      assert Activities.list_acted_activities() == [acted_activity]
    end

    test "get_acted_activity!/1 returns the acted_activity with given id" do
      acted_activity = acted_activity_fixture()
      assert Activities.get_acted_activity!(acted_activity.id) == acted_activity
    end

    test "create_acted_activity/1 with valid data creates a acted_activity" do
      valid_attrs = %{begin_timestamp: ~N[2023-01-19 12:23:00], end_timestamp: ~N[2023-01-19 12:23:00]}

      assert {:ok, %ActedActivity{} = acted_activity} = Activities.create_acted_activity(valid_attrs)
      assert acted_activity.begin_timestamp == ~N[2023-01-19 12:23:00]
      assert acted_activity.end_timestamp == ~N[2023-01-19 12:23:00]
    end

    test "create_acted_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_acted_activity(@invalid_attrs)
    end

    test "update_acted_activity/2 with valid data updates the acted_activity" do
      acted_activity = acted_activity_fixture()
      update_attrs = %{begin_timestamp: ~N[2023-01-20 12:23:00], end_timestamp: ~N[2023-01-20 12:23:00]}

      assert {:ok, %ActedActivity{} = acted_activity} = Activities.update_acted_activity(acted_activity, update_attrs)
      assert acted_activity.begin_timestamp == ~N[2023-01-20 12:23:00]
      assert acted_activity.end_timestamp == ~N[2023-01-20 12:23:00]
    end

    test "update_acted_activity/2 with invalid data returns error changeset" do
      acted_activity = acted_activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_acted_activity(acted_activity, @invalid_attrs)
      assert acted_activity == Activities.get_acted_activity!(acted_activity.id)
    end

    test "delete_acted_activity/1 deletes the acted_activity" do
      acted_activity = acted_activity_fixture()
      assert {:ok, %ActedActivity{}} = Activities.delete_acted_activity(acted_activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_acted_activity!(acted_activity.id) end
    end

    test "change_acted_activity/1 returns a acted_activity changeset" do
      acted_activity = acted_activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_acted_activity(acted_activity)
    end
  end
end
