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
    activity = Activity.objects.get(id=activity_id)
    acted_activity = ActedActivity(
        finished=timezone.now(),
        activity=activity)
    acted_activity.save()
    messages.success(
        request, f"<b>{activity.name}</b> was added successfully!")
    return redirect('index')


def remove_acted_activity(request, actedactivity_id):
    acted_activity = ActedActivity.objects.get(id=actedactivity_id)
    activity_name = acted_activity.activity.name
    acted_activity.delete()
    messages.success(
        request, f"<b>{activity_name}</b> was removed successfully!")
    return redirect('index')
