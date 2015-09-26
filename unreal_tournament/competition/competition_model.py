__author__ = 'pong'

from django.db import models
from unreal_tournament.models import PtsTable, Tournament
from django.utils import timezone

# import your models here.


class Competition(models.Model):
    name = models.TextField()
    play_date = models.DateTimeField(default=timezone.now)
    phase = models.TextField(default='phase 1')
    enabled = models.BooleanField(default=False)
    pts_ref = models.ForeignKey(PtsTable, db_column='pts_ref')
    tournament = models.ForeignKey(Tournament, db_column='tournament')

    class Meta:
        managed = False
        db_table = 'competition'
        unique_together = (('id', 'tournament'), ('name', 'tournament'),)
