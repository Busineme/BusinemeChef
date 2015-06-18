# -*- coding: utf-8 -*-
import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))


# Database configuration

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'busine-me',
        'USER': 'postgres',
        'PASSWORD': '1qaz2wsx',
        'HOST': 'localhost',
        'PORT': '',
    }
}
