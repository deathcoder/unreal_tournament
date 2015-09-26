__author__ = 'pong'

from django.db import models

# import your models here.


class PtsTable(models.Model):
    type = models.TextField()
    rank = models.IntegerField()
    award_pts = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'pts_table'
        unique_together = (('type', 'rank'),)
