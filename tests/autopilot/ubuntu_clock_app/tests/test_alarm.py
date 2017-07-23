# Copyright (C) 2014-2016 Canonical Ltd
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

"""Tests for the Clock App - Alarm"""

from __future__ import absolute_import

from datetime import datetime, timedelta

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_clock_app.tests import ClockAppTestCase


class TestAlarm(ClockAppTestCase):
    """Tests the alarm page features"""

    scenarios = [
        ('random',
            {'alarm_name': 'Random days Alarm Test',
             'days': ['Tuesday', 'Wednesday', 'Friday', 'Sunday'],
             'expected_recurrence': 'Tue, Wed, Fri, Sun',
             'enabled_value': True,
             'sound_name': 'Bliss',
			 'edited_alarm_name': 'Random days Alarm Test Edited',
             'edited_days': ['Thursday'],
             'edited_expected_recurrence': 'Thu',
             'edited_enabled_value': True,
             'edited_sound_name': 'Celestial'
             }),

        ('weekday',
            {'alarm_name': 'Weekday Alarm Test',
             'days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
             'expected_recurrence': 'Weekdays',
             'enabled_value': True,
             'sound_name': 'Bliss',
			 'edited_alarm_name': 'Weekday Alarm Test Edited',
             'edited_days':  ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
             'edited_expected_recurrence': 'Daily',
             'edited_enabled_value': True,
             'edited_sound_name': 'Counterpoint',
             }),

        ('weekend',
            {'alarm_name': 'Weekend Alarm Test',
             'days': ['Saturday', 'Sunday'],
             'expected_recurrence': 'Weekends',
             'enabled_value': True,
             'sound_name': 'Bliss',
             'edited_alarm_name': 'Weekend Alarm Test Edited',
			 'edited_days': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
             'edited_expected_recurrence': 'Daily',
             'edited_enabled_value': True,
             'edited_sound_name': 'Celestial'
             })
    ]

    def setUp(self):
        """This is needed to wait for the application to start.

        In the testfarm, the application may take some time to show up.

        """
        super(TestAlarm, self).setUp()
        self.assertThat(
            self.app.main_view.visible, Eventually(Equals(True)))

        self.page = self.app.main_view.open_alarm()

    def test_remove_all_alarms(self):
        alarmlistPage = self.app.main_view.get_AlarmList()
        alarmscount = alarmlistPage.get_saved_alarms_count()
        for idx in range(alarmscount):
           alarmlistPage.delete_alarm(index=0)

        savedAlarmsCount = alarmlistPage.get_saved_alarms_count()
        self.assertEqual(0, savedAlarmsCount)

    def test_add_recurring_type_alarm_must_add_to_alarm_list(self):
        """Test to check if alarms are saved properly

        This test saves some random days, weekends and weekdays types of alarm
        and verifies if they are added to the alarm list in the alarm page.

        """
        time_to_set = datetime.now() + timedelta(minutes=5)
        formatted_time_to_set = time_to_set.time()
        time_to_set_string = format(time_to_set, '%H:%M')

        expected_alarm_info = (
            self.alarm_name, self.expected_recurrence,
            time_to_set_string, self.enabled_value)

        self.page.add_single_alarm(
            self.alarm_name, self.days, formatted_time_to_set,
            self.sound_name)

        alarmlistPage = self.app.main_view.get_AlarmList()
        saved_alarms = alarmlistPage.get_saved_alarms()
        self.assertIn(expected_alarm_info, saved_alarms)

        # TODO: Remove this statement once proper support for cleaning the
        # test alarm environment is added. Until then remove the alarm
        # created during the test at the end of the test.
        # -- nik90 - 2014-03-03
        alarmlistPage.delete_alarm(index=0)

    def test_add_and_edit_alarm_in_list(self):
        """Test to check if alarms are saved properly

        This test saves some random days, weekends and weekdays types of alarm
        and verifies if they are added to the alarm list in the alarm page.
        and then test editing those values.

        """
        time_to_set = datetime.now() + timedelta(minutes=5)
        formatted_time_to_set = time_to_set.time()
        time_to_set_string = format(time_to_set, '%H:%M')

        expected_alarm_info = (
            self.alarm_name, self.expected_recurrence,
            time_to_set_string, self.enabled_value)

        added_alarm = self.page.add_single_alarm(
            self.alarm_name, self.days, formatted_time_to_set,
            self.sound_name)

        """alarmlistPage = self.app.main_view.get_AlarmList()
        saved_alarms = alarmlistPage.get_saved_alarms()
        self.assertIn(expected_alarm_info, saved_alarms)"""

        edited_expected_alarm_info = (
            self.edited_alarm_name, self.edited_expected_recurrence,
            time_to_set_string, self.edited_enabled_value)

        self.page.edit_single_alarm( added_alarm,
            self.edited_alarm_name, self.edited_days, formatted_time_to_set,
            self.edited_sound_name)

        alarmlistPage = self.app.main_view.get_AlarmList()
        saved_alarms = alarmlistPage.get_saved_alarms()
        self.assertIn(edited_expected_alarm_info, saved_alarms)

        # TODO: Remove this statement once proper support for cleaning the
        # test alarm environment is added. Until then remove the alarm
        # created during the test at the end of the test.
        # -- nik90 - 2014-03-03
        alarmlistPage.delete_alarm(index=0)
