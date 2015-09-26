__author__ = 'pong'

from django.db import models

# Create your models here.


class Player(models.Model):
    username = models.TextField(unique=True)
    password = models.TextField()
    name = models.TextField(blank=True, null=True)
    surname = models.TextField(blank=True, null=True)
    enabled = models.BooleanField(default=True)
    admin = models.BooleanField(default=False)

    class Meta:
        managed = False
        db_table = 'player'
