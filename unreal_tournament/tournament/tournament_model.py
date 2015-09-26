__author__ = 'pong'

from django.db import models
from unreal_tournament.models import Player

# Create your models here.


class Tournament(models.Model):
    name = models.TextField(unique=True)
    edition = models.TextField(default='first')
    type = models.TextField(default='italian')
    competitions = models.IntegerField()
    min_regs = models.IntegerField(default=2)
    max_regs = models.IntegerField(default=2)
    enabled = models.BooleanField(default=False)
    start_reg = models.DateField(blank=True, null=True)
    end_reg = models.DateField(blank=True, null=True)
    organizer = models.ForeignKey(Player, db_column='organizer')

    class Meta:
        managed = False
        db_table = 'tournament'
        unique_together = (('name', 'edition'),)
