# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2014 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Clock app autopilot fixtures."""

import fixtures
import subprocess


class LocationServiceTestEnvironment(fixtures.Fixture):

    def setUp(self):
        super(LocationServiceTestEnvironment, self).setUp()
        self._set_location_service_testing(True)
        self.addCleanup(self._set_location_service_testing(False))

def _set_location_service_testing(test_mode):
    test = 'true' if test_mode else 'false'
    try:
        subprocess.check_call(
            'sudo setprop custom.location.testing {}'.format(test),
            shell=True)
        subprocess.check_call(
            'sudo restart ubuntu-location-service && '
            'restart ubuntu-location-service-trust-stored',
            shell=True)
    except subprocess.CalledProcessError:
        print('Unable to start location service in testing mode '
              'tests may fail as a result.')
