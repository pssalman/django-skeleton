__author__ = 'anton.salman@gmail.com'

import uuid

from django.conf import settings
from django.db import models
from django.utils.translation import gettext_lazy as _


# Create your models here.
class CreatedByModel(models.Model):

    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        default=1,
        verbose_name=_("created by"),
    )

    class Meta:
        abstract = True


class SlugModel(models.Model):

    slug = models.SlugField(
        _('slug'),
        unique=True, max_length=250,
        allow_unicode=True, db_index=True,
        help_text=_('Universally unique slug'),
    )

    class Meta:
        abstract = True


class UUIDModel(models.Model):

    uuid = models.UUIDField(
        _('uuid'),
        default=uuid.uuid4, editable=False,
        unique=True, db_index=True,
        help_text=_('Universally unique identifier'),
    )

    class Meta:
        abstract = True


class TimeStampedModel(models.Model):

    """
    An abstract base class model that provides self
    updating ``created`` and ``modified`` fields.
    """
    created_at = models.DateTimeField(
        _('created_at'),
        auto_now_add=True,
        help_text=_('Created at datetime field'),
    )
    modified_at = models.DateTimeField(
        _('modified_at'),
        auto_now=True,
        help_text=_('Modified at datetime field'),
    )

    class Meta:
        abstract = True


class IpModel(models.Model):

    ip_address = models.GenericIPAddressField(
        protocol='IPv4', default='127.0.0.1',
    )

    class Meta:
        abstract = True


class UUIDTimeStampedModel(UUIDModel, TimeStampedModel):

    class Meta:
        abstract = True


class UUIDSlugModel(UUIDModel, SlugModel):

    class Meta:
        abstract = True


class UUIDSlugTimeStampedModel(UUIDModel, SlugModel, TimeStampedModel):

    class Meta:
        abstract = True


class UUIDSlugIpTimeStampedModel(
        UUIDModel,
        SlugModel,
        IpModel,
        TimeStampedModel):

    class Meta:
        abstract = True


class CoreAppModel(
        UUIDModel,
        CreatedByModel,
        SlugModel,
        IpModel,
        TimeStampedModel):

    class Meta:
        abstract = True