__author__ = 'pong'

from django.db import models
from unreal_tournament.models import Player, Tournament

# Create your models here.


class Registration(models.Model):
    player = models.ForeignKey(Player, db_column='player')
    fee = models.DecimalField(max_digits=12, decimal_places=2)
    points = models.IntegerField(blank=True, null=True, default=0)
    tournament = models.ForeignKey(Tournament, db_column='tournament')

    class Meta:
        managed = False
        db_table = 'registration'
        unique_together = (('id', 'tournament'), ('player', 'tournament'),)
