defmodule Track.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Track.Repo

  alias Track.Activities.Activity

  @doc """
  Returns the list of activities.

  ## Examples

      iex> list_activities()
      [%Activity{}, ...]

  """
  def list_activities do
    Repo.all(Activity)
  end

  @doc """
  Gets a single activity.

  Raises `Ecto.NoResultsError` if the Activity does not exist.

  ## Examples

      iex> get_activity!(123)
      %Activity{}

      iex> get_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_activity!(id), do: Repo.get!(Activity, id)

  @doc """
  Creates a activity.

  ## Examples

      iex> create_activity(%{field: value})
      {:ok, %Activity{}}

      iex> create_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a activity.

  ## Examples

      iex> update_activity(activity, %{field: new_value})
      {:ok, %Activity{}}

      iex> update_activity(activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_activity(%Activity{} = activity, attrs) do
    activity
    |> Activity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a activity.

  ## Examples

      iex> delete_activity(activity)
      {:ok, %Activity{}}

      iex> delete_activity(activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_activity(%Activity{} = activity) do
    Repo.delete(activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity changes.

  ## Examples

      iex> change_activity(activity)
      %Ecto.Changeset{data: %Activity{}}

  """
  def change_activity(%Activity{} = activity, attrs \\ %{}) do
    Activity.changeset(activity, attrs)
  end

  alias Track.Activities.ActedActivity

  @doc """
  Returns the list of acted_activities.

  ## Examples

      iex> list_acted_activities()
      [%ActedActivity{}, ...]

  """
  def list_acted_activities do
    query =
      from aa in ActedActivity,
        join: a in Activity,
        on: aa.activity_id == a.id,
        select_merge: %{activity_title: a.title}

    Repo.all(query)
  end

  @doc """
  Gets a single acted_activity.

  Raises `Ecto.NoResultsError` if the Acted activity does not exist.

  ## Examples

      iex> get_acted_activity!(123)
      %ActedActivity{}

      iex> get_acted_activity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_acted_activity!(id), do: Repo.get!(ActedActivity, id)

  @doc """
  Creates a acted_activity.

  ## Examples

      iex> create_acted_activity(%{field: value})
      {:ok, %ActedActivity{}}

      iex> create_acted_activity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_acted_activity(attrs \\ %{}) do
    %ActedActivity{}
    |> ActedActivity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a acted_activity.

  ## Examples

      iex> update_acted_activity(acted_activity, %{field: new_value})
      {:ok, %ActedActivity{}}

      iex> update_acted_activity(acted_activity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_acted_activity(%ActedActivity{} = acted_activity, attrs) do
    acted_activity
    |> ActedActivity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a acted_activity.

  ## Examples

      iex> delete_acted_activity(acted_activity)
      {:ok, %ActedActivity{}}

      iex> delete_acted_activity(acted_activity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_acted_activity(%ActedActivity{} = acted_activity) do
    Repo.delete(acted_activity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking acted_activity changes.

  ## Examples

      iex> change_acted_activity(acted_activity)
      %Ecto.Changeset{data: %ActedActivity{}}

  """
  def change_acted_activity(%ActedActivity{} = acted_activity, attrs \\ %{}) do
    ActedActivity.changeset(acted_activity, attrs)
  end
end
