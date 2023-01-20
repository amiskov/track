defmodule Track.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :title, :string
    field :activity_type, Ecto.Enum, values: [:bad, :good, :necessary]

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :activity_type])
    |> validate_required([:title, :activity_type])
    |> unique_constraint(:title, name: :index_activities_title_unique)
  end
end
