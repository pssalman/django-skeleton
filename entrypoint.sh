#!/bin/sh

export DJANGO_SETTINGS_MODULE=conf.settings.${ENV}

python -c "import django; print('django version:', django.get_version())"
python manage.py wait_for_db
#python manage.py flush --no-input
python manage.py makemigrations
python manage.py migrate --no-input
python manage.py create_super
python manage.py collectstatic --no-input

#python manage.py makemessages -l ar
#python manage.py makemessages -l fr
#python manage.py makemessages -l de
python manage.py compilemessages

#from django.utils import translation
#user_language = 'fr'
#translation.activate(user_language)
#request.session[translation.LANGUAGE_SESSION_KEY] = user_language 

#from django.utils import translation
#from django import http
#from django.conf import settings
#user_language = 'fr'
#translation.activate(user_language)
#response = http.HttpResponse(...)
#response.set_cookie(settings.LANGUAGE_COOKIE_NAME, user_language)

# Prepare log files and start outputting logs to stdout
touch ./logs/gunicorn/gunicorn-${ENV}.log
touch ./logs/gunicorn/gunicorn-access-${ENV}.log
tail -n 0 -f ./logs/gunicorn/gunicorn*.log &

echo Starting Gunicorn.

exec gunicorn conf.wsgi:application \
    --name webapp_django \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers 3 \
    --log-level=info \
    --log-file=./logs/gunicorn/gunicorn-${ENV}.log \
    --access-logfile=./logs/gunicorn/gunicorn-access-${ENV}.log