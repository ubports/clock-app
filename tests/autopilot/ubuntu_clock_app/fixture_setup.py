# Copyright (C) 2014-2015 Canonical Ltd
#
# This file is part of Ubuntu Clock App
#
# Ubuntu Clock App is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# Ubuntu Clock App is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""Clock app autopilot fixtures."""

import fixtures
import logging
import subprocess


class LocationServiceTestEnvironment(fixtures.Fixture):

    def setUp(self):
        super(LocationServiceTestEnvironment, self).setUp()
        self._set_location_service_testing(True)
        self.addCleanup(self._set_location_service_testing, False)

    def _set_location_service_testing(self, test_mode):
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
            logger = logging.getLogger(__name__)
            logger.error('Unable to start location service in testing mode '
                         'tests may fail as a result.')
