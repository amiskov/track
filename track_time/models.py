from django.db import models
from django.db.models.fields.related import ForeignKey
from django.utils.translation import gettext_lazy as _


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
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE)

    class Meta:
        verbose_name_plural = "Acted Activities"

    def __str__(self):
        return self.activity.name
