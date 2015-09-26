__author__ = 'pong'

# import all settings in this directory - should be edited when creating new ones

from ut_backend.settings.settings import *

try:
    from ut_backend.settings.local_settings import *
except ImportError:
    pass
