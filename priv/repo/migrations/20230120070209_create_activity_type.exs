defmodule Track.Repo.Migrations.CreateActivityType do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE activity_type AS ENUM ('bad', 'good', 'necessary')"
    drop_query = "DROP TYPE activity_type"

    # This macro is responsible for `up` and `down` migrations.
    execute(create_query, drop_query)
  end
end
