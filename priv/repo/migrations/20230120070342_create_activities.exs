defmodule Track.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :string, null: false
      add :activity_type, :activity_type, null: false

      timestamps()
    end

    create(
      unique_index(
        :activities,
        ~w(title)a,
        name: :index_activities_title_unique
      )
    )
  end
end
