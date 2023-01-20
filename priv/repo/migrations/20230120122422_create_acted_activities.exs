defmodule Track.Repo.Migrations.CreateActedActivities do
  use Ecto.Migration

  def change do
    create table(:acted_activities) do
      add :activity_id, references(:activities, on_delete: :delete_all), null: false
      add :begin_timestamp, :naive_datetime, null: false
      add :end_timestamp, :naive_datetime, null: false

      timestamps()
    end

    create index(:acted_activities, [:activity_id])
  end
end
