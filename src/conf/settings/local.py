import socket

from .base import *  # noqa
from .base import env

ALLOWED_HOSTS = [
    'localhost',
    '0.0.0.0',
    '127.0.0.1'
]

INTERNAL_IPS = [
    '127.0.0.1',
]

INSTALLED_APPS += ['debug_toolbar', 'django_extensions']  # noqa F405

LOCAL_IP = str(socket.gethostbyname(socket.gethostname()))

print('hostname: ' + socket.gethostname())
print('hostbyip: ' + LOCAL_IP)

# Database
# https://docs.djangoproject.com/en/2.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

MIDDLEWARE += ["debug_toolbar.middleware.DebugToolbarMiddleware"]  # noqa F405
DEBUG_TOOLBAR_CONFIG = {
    "DISABLE_PANELS": ["debug_toolbar.panels.redirects.RedirectsPanel"],
    "SHOW_TEMPLATE_CONTEXT": True,
}

CELERY_TASK_EAGER_PROPAGATES = True