# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Copyright (C) 2014 Canonical Ltd
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
#
# Authored by: Nicholas Skaggs <nicholas.skaggs@canonical.com>
#              Nekhelesh Ramananthan <krnekhelesh@gmail.com>

"""Tests for the Clock App - Alarm"""

from __future__ import absolute_import

import datetime

from autopilot.matchers import Eventually
from testtools.matchers import Equals
from ubuntu_clock_app.tests import ClockAppTestCase


class TestAlarm(ClockAppTestCase):

    """Tests the alarm page features"""

    def setUp(self):
        """ This is needed to wait for the application to start.

        In the testfarm, the application may take some time to show up.

        """
        super(TestAlarm, self).setUp()
        self.assertThat(
            self.main_view.visible, Eventually(Equals(True)))

        self.page = self.main_view.open_alarm()

    def test_add_single_type_alarm_must_add_to_alarm_list(self):
        """Test to check if a single type alarm is saved properly

        This test saves a single type alarm and verifies if it is added to the
        alarm list in the alarm page.

        """
        tomorrow = datetime.datetime.now() + datetime.timedelta(days=1)
        time_to_set = datetime.time(6, 10, 0)
        test_alarm_name = 'Single Test'
        # TODO this will be affected by the locale. --elopio - 2014-02-27
        expected_alarm_name = test_alarm_name
        expected_recurrence = tomorrow.strftime('%A')
        expected_enabled_value = True
        expected_time = "06:10:00"
        test_sound_name = "Bliss"
        expected_alarm_info = (
            expected_alarm_name, expected_recurrence, expected_enabled_value,
            expected_time)

        tomorrow_day = tomorrow.strftime('%A')
        self.page.add_single_alarm(
            test_alarm_name, tomorrow_day, time_to_set, test_sound_name)

        alarmlistPage = self.main_view.get_AlarmList()
        saved_alarms = alarmlistPage.get_saved_alarms()
        self.assertIn(expected_alarm_info, saved_alarms)

        # TODO: Remove this statement once proper support for cleaning the
        # test alarm environment is added. Until then remove the alarm
        # created during the test at the end of the test.
        # -- nik90 - 2014-03-03
        alarmlistPage.delete_alarm(index=0)
