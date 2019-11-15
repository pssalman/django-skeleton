__author__ = 'anton.salman@gmail.com'

from django.contrib.auth.models import User
from django.core.management.base import BaseCommand
from django.utils.crypto import get_random_string


class Command(BaseCommand):
    """Django command that creates random number of users"""

    help = 'Create random users'

    def add_arguments(self, parser):
        """Create users command parameters"""

        parser.add_argument('total',
                            type=int,
                            help='Indicates the number of users to be created')
        parser.add_argument('-p', '--prefix',
                            type=str,
                            help='Define a username prefix')
        parser.add_argument('-a',
                            '--admin',
                            action='store_true',
                            help='Create an admin account')

    def handle(self, *args, **kwargs):
        """Handle the create_users command"""

        total = kwargs['total']
        prefix = kwargs['prefix']
        admin = kwargs['admin']

        for _ in range(total):
            if prefix:
                username = f'{prefix}_{get_random_string()}'
            else:
                username = get_random_string()

            if admin:
                User.objects.create_superuser(
                    username=username, email='',
                    password='123'
                )
            else:
                User.objects.create_user(
                    username=username, email='',
                    password='123'
                )