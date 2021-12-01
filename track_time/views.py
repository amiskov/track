from django.http.response import HttpResponse
from django.shortcuts import redirect, render
from django.contrib import messages
from django.utils import timezone


from .models import ActedActivity, Activity


def index(request):
    activities = Activity.objects.order_by('activity_type')

    context = {
        'activities': activities,
        'acted_activities': ActedActivity.acted_today(),
    }

    return render(request, 'track_time/index.html', context)


def add_acted_activity(request, activity_id):
    added_acted_activity = ActedActivity.add(activity_id)
    messages.success(
        request, f"<b>{added_acted_activity.activity.name}</b> was added successfully!")
    return redirect('index')


def add_acted_activity_api(request, activity_id):
    if request.method == "GET":
        added_acted_activity = ActedActivity.add(activity_id)
        print(added_acted_activity)
        return HttpResponse(f"{added_acted_activity.activity.name} was added successfully!")
    else:
        messages.error(request, f"Use GET method.")
        return redirect('index')


def remove_acted_activity(request, actedactivity_id):
    acted_activity = ActedActivity.objects.get(id=actedactivity_id)
    activity_name = acted_activity.activity.name
    acted_activity.delete()
    messages.success(
        request, f"<b>{activity_name}</b> was removed successfully!")
    return redirect('index')
