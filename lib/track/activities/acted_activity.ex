defmodule Track.Activities.ActedActivity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "acted_activities" do
    field :activity_id, :id
    field :begin_timestamp, :utc_datetime
    field :end_timestamp, :utc_datetime
    field :activity_title, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(acted_activity, attrs) do
    acted_activity
    |> cast(attrs, [:activity_id, :begin_timestamp, :end_timestamp])
    |> validate_required([:activity_id, :begin_timestamp, :end_timestamp])
  end
end
