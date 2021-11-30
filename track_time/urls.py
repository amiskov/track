from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('<int:activity_id>/add/',
         views.add_acted_activity,
         name='add_acted_activity'),
]
