from collections import defaultdict
from django.db import models
from django.db.models.fields.related import ForeignKey
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from datetime import timedelta
from humanize import naturaldelta


class Activity(models.Model):
    name = models.CharField(max_length=512)

    class Meta:
        verbose_name_plural = "Activities"

    class Type(models.TextChoices):
        GOOD = "good", _('Good')
        BAD = "bad", _('Bad')
        NECESSARY = "necessary", _('Necessary')

    activity_type = models.CharField(
        max_length=56,
        choices=Type.choices,
        default=Type.NECESSARY,
    )

    def __str__(self):
        return self.name


class ActedActivity(models.Model):
    finished = models.DateTimeField('date finished')
    activity = models.ForeignKey(Activity, on_delete=models.RESTRICT)

    def add(activity_id):
        activity = Activity.objects.get(id=activity_id)
        acted_activity = ActedActivity(
            finished=timezone.now(),
            activity=activity)
        acted_activity.save()
        return acted_activity

    def acted_today():
        today = timezone.now()
        today_activities = ActedActivity.objects.filter(
            # 24 hours:
            # finished__gte=(timezone.now() - timedelta(days=1))

            # only today after 5 AM:
            finished__year=today.year, finished__month=today.month, finished__day=today.day, finished__hour__gte=5
        ).order_by('-finished')

        seconds_by_type = defaultdict(int)

        for i, today_activity in enumerate(today_activities):
            is_earliest = (i == len(today_activities) - 1)

            duration = timedelta(seconds=0) if is_earliest \
                else (today_activity.finished - today_activities[i + 1].finished)

            seconds_by_type[today_activity.activity.activity_type] += duration.seconds

            today_activity.duration = naturaldelta(duration)

        # must be non zero
        total_seconds = max(sum(seconds_by_type.values()), 1)

        percents_by_type = defaultdict(int)
        for k, v in seconds_by_type.items():
            percents_by_type[k] = round(v / total_seconds * 100)

        today_activities.labels = str(list(percents_by_type.keys()))
        today_activities.values = str(list(percents_by_type.values()))
        today_activities.total_seconds = total_seconds

        return today_activities

    class Meta:
        verbose_name_plural = "Acted Activities"

    def __str__(self):
        return self.activity.name + ", " + self.finished.strftime("%y-%m-%d %H:%M")
