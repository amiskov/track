defmodule TrackWeb.ActedActivityLiveTest do
  use TrackWeb.ConnCase

  import Phoenix.LiveViewTest
  import Track.ActivitiesFixtures

  @create_attrs %{begin_timestamp: %{day: 19, hour: 12, minute: 23, month: 1, year: 2023}, end_timestamp: %{day: 19, hour: 12, minute: 23, month: 1, year: 2023}}
  @update_attrs %{begin_timestamp: %{day: 20, hour: 12, minute: 23, month: 1, year: 2023}, end_timestamp: %{day: 20, hour: 12, minute: 23, month: 1, year: 2023}}
  @invalid_attrs %{begin_timestamp: %{day: 30, hour: 12, minute: 23, month: 2, year: 2023}, end_timestamp: %{day: 30, hour: 12, minute: 23, month: 2, year: 2023}}

  defp create_acted_activity(_) do
    acted_activity = acted_activity_fixture()
    %{acted_activity: acted_activity}
  end

  describe "Index" do
    setup [:create_acted_activity]

    test "lists all acted_activities", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.acted_activity_index_path(conn, :index))

      assert html =~ "Listing Acted activities"
    end

    test "saves new acted_activity", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.acted_activity_index_path(conn, :index))

      assert index_live |> element("a", "New Acted activity") |> render_click() =~
               "New Acted activity"

      assert_patch(index_live, Routes.acted_activity_index_path(conn, :new))

      assert index_live
             |> form("#acted_activity-form", acted_activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#acted_activity-form", acted_activity: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acted_activity_index_path(conn, :index))

      assert html =~ "Acted activity created successfully"
    end

    test "updates acted_activity in listing", %{conn: conn, acted_activity: acted_activity} do
      {:ok, index_live, _html} = live(conn, Routes.acted_activity_index_path(conn, :index))

      assert index_live |> element("#acted_activity-#{acted_activity.id} a", "Edit") |> render_click() =~
               "Edit Acted activity"

      assert_patch(index_live, Routes.acted_activity_index_path(conn, :edit, acted_activity))

      assert index_live
             |> form("#acted_activity-form", acted_activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#acted_activity-form", acted_activity: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acted_activity_index_path(conn, :index))

      assert html =~ "Acted activity updated successfully"
    end

    test "deletes acted_activity in listing", %{conn: conn, acted_activity: acted_activity} do
      {:ok, index_live, _html} = live(conn, Routes.acted_activity_index_path(conn, :index))

      assert index_live |> element("#acted_activity-#{acted_activity.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#acted_activity-#{acted_activity.id}")
    end
  end

  describe "Show" do
    setup [:create_acted_activity]

    test "displays acted_activity", %{conn: conn, acted_activity: acted_activity} do
      {:ok, _show_live, html} = live(conn, Routes.acted_activity_show_path(conn, :show, acted_activity))

      assert html =~ "Show Acted activity"
    end

    test "updates acted_activity within modal", %{conn: conn, acted_activity: acted_activity} do
      {:ok, show_live, _html} = live(conn, Routes.acted_activity_show_path(conn, :show, acted_activity))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Acted activity"

      assert_patch(show_live, Routes.acted_activity_show_path(conn, :edit, acted_activity))

      assert show_live
             |> form("#acted_activity-form", acted_activity: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#acted_activity-form", acted_activity: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.acted_activity_show_path(conn, :show, acted_activity))

      assert html =~ "Acted activity updated successfully"
    end
  end
end
