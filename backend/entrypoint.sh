#!/bin/sh
if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."
    
    while ! nc -z $DB_HOST $DB_PORT; do
      sleep 0.1
    done
    
    echo "PostgreSQL started"
fi

python backend/django_app/manage.py collectstatic --noinput
python backend/django_app/manage.py nakemigrations --noinput
python backend/django_app/manage.py migrate --noinput
echo "from django.contrib.auth.models import User;
User.objects.filter(email='$DJANGO_ADMIN_EMAIL').delete();
User.objects.create_superuser('$DJANGO_ADMIN_USER', '$DJANGO_ADMIN_EMAIL', '$DJANGO_ADMIN_PASSWORD')" | python backend/django_app/manage.py shell

exec "$@"