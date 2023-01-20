# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Track.Repo.insert!(%Track.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Track.Activities

activities = [
  %{title: "🐱 🐶 Pets", activity_type: "necessary"},
  %{title: "🔮 Planning/Reflecting", activity_type: "good"},
  %{title: "💰 Working", activity_type: "good"},
  %{title: "🎻 Play Music", activity_type: "good"},
  %{title: "💆🏻 Self Care", activity_type: "good"},
  %{title: "🛌 Sleep", activity_type: "necessary"},
  %{title: "🗑 Wasted Time", activity_type: "bad"},
  %{title: "📖 Reading", activity_type: "good"},
  %{title: "🏡 Yard Maintenance", activity_type: "good"},
  %{title: "💰 Big House Preparation", activity_type: "good"},
  %{title: "🪴 Housekeeping", activity_type: "necessary"},
  %{title: "🧠 Learning", activity_type: "good"},
  %{title: "🔄 Misc", activity_type: "necessary"},
  %{title: "🧘 Rest", activity_type: "necessary"},
  %{title: "🛒 Shopping", activity_type: "necessary"},
  %{title: "🛀 Hygiene", activity_type: "necessary"},
  %{title: "🥘 Eating, Cooking, Washing Dishes", activity_type: "necessary"},
  %{title: "🚀 My projects", activity_type: "good"}
]

Enum.each(activities, fn a ->
  IO.inspect(a)
  {:ok, _} = Activities.create_activity(a)
end)
