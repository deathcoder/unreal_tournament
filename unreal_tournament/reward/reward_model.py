__author__ = 'pong'

from django.db import models
from unreal_tournament.models import Tournament

# Create your models here.


class Reward(models.Model):
    # django doesn't support composite primary keys
    # this hack delegates to the db to enforce it
    tournament = models.ForeignKey(Tournament, db_column='tournament', primary_key=True)
    rank = models.IntegerField()
    reward = models.TextField()

    class Meta:
        managed = False
        db_table = 'reward'
        unique_together = (('tournament', 'rank'),)
