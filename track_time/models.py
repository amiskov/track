from collections import defaultdict
from django.db import models
from django.db.models.fields.related import ForeignKey
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from datetime import timedelta, datetime
from humanize import precisedelta


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

    def get_acted_for_day(day: datetime):
        acted = ActedActivity.objects.filter(
            # only today after 5 AM:
            finished__year=day.year, finished__month=day.month, finished__day=day.day, finished__hour__gte=5
        ).order_by('-finished')
        seconds_by_type = defaultdict(int)

        for i, today_activity in enumerate(acted):
            is_earliest = (i == len(acted) - 1)

            duration = timedelta(seconds=0) if is_earliest \
                else (today_activity.finished - acted[i + 1].finished)

            seconds_by_type[today_activity.activity.activity_type] += duration.seconds

            today_activity.duration = precisedelta(
                duration, minimum_unit="minutes", format="%0.0f")

        # must be non zero
        total_seconds = max(sum(seconds_by_type.values()), 1)

        percents_by_type = defaultdict(int)
        # Alphabetically sorted by labels
        for k, v in sorted(seconds_by_type.items(), key=lambda e: e[0]):
            percents_by_type[k] = round(v / total_seconds * 100)

        acted.all = str(dict(percents_by_type))
        acted.labels = str(list(percents_by_type.keys()))
        acted.values = str(list(percents_by_type.values()))
        acted.total_seconds = total_seconds
        return acted

    @classmethod
    def acted_today(self):
        today = timezone.now()
        return self.get_acted_for_day(today)

    class Meta:
        verbose_name_plural = "Acted Activities"

    def __str__(self):
        return self.activity.name + ", " + self.finished.strftime("%y-%m-%d %H:%M")
