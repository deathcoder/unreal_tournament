__author__ = 'pong'

from django.db import models
from unreal_tournament.models import Registration, Competition, Tournament
from datetime import datetime

# import your models here.


class Opponent(models.Model):
    registration = models.ForeignKey(Registration, db_column='registration', primary_key=True)
    competition = models.ForeignKey(Competition, db_column='competition')
    ranking = models.IntegerField(blank=True, null=True)
    tournament = models.ForeignKey(Tournament, db_column='tournament')

    class Meta:
        managed = False
        db_table = 'opponent'
        unique_together = (('registration', 'competition'),)
