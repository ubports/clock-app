# Copyright (C) 2016 Canonical Ltd
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

"""
Tests for the Clock App, stopwatch page.
"""

from __future__ import absolute_import

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_clock_app.tests import ClockAppTestCase


class TestStopwatch(ClockAppTestCase):
    """Tests the stopwatch feature"""

    def setUp(self):
        """This is needed to wait for the application to start.

        In the testfarm, the application may take some time to show up.

        """
        super(TestStopwatch, self).setUp()
        self.assertThat(
            self.app.main_view.visible, Eventually(Equals(True)))

        self.page = self.app.main_view.open_stopwatch()

    def test_pressing_gui_button_starts_stops_clears_stopwatch(self):
        """Test to check if stopwatch can be started, stopped and
        cleared using the UI buttons"""

        self.page.start_stopwatch()
        self.page.stop_stopwatch()
        self.page.clear_stopwatch()

    def test_pressing_lap_button_adds_laps(self):
        """Test to check if stopwatch laps can be created"""
        self.page.start_stopwatch()
        self.page.add_lap()
        self.page.clean_up_test()

    def test_swipe_delete_button_deletes_laps(self):
        """Test to check if laps can be deleted by swiping right"""
        self.page.start_stopwatch()
        self.page.add_lap()
        self.page.delete_lap(0)
        self.page.clean_up_test()
