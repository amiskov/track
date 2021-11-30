from django.contrib import admin
from .models import Activity

# admin.site.register(Activity)


@admin.register(Activity)
class ActivityAdmin(admin.ModelAdmin):
    list_display = ('name', 'activity_type', 'id')
    list_filter = ('activity_type', )
