__author__ = 'anton.salman@gmail.com'

import os
# from django.core.management.base import CommandError
from django.core.management.base import (
    BaseCommand,
    no_translations
)
from django.contrib.auth.models import User
from django.conf import settings
# from django.contrib.auth import get_user_model


class Command(BaseCommand):
    """Django command that creates super admin user"""

    help = 'Creates superadmin user at runtime'

    @no_translations
    def handle(self, *args, **options):
        """Handle the create_super command"""

        # User = get_user_model()
        if User.objects.count() == 0:
            for user in settings.ADMINS:
                username = user[0].replace(' ', '')
                email = user[1]
                password = os.environ['ADMIN_PASSWORD']
                print(f'Creating account for {username} - {email}')
                admin = User.objects.create_superuser(
                    email=email, username=username,
                    password=password
                )
                admin.is_active = True
                admin.is_admin = True
                admin.save()
            self.stdout.write(
                self.style.SUCCESS(
                    'Successfully created superadmin'
                )
            )
        else:
            self.stdout.write(
                self.style.NOTICE(
                    """Admin accounts can only be
                    initialized if no Accounts exist"""
                )
            )