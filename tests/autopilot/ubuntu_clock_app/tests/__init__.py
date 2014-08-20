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

"""clock-app autopilot tests."""

import os.path
import os
import shutil
import glob
import logging
import fixtures

from autopilot import logging as autopilot_logging
from ubuntuuitoolkit import (
    base,
    emulators as toolkit_emulators
)

from ubuntu_clock_app import emulators

logger = logging.getLogger(__name__)


class ClockAppTestCase(base.UbuntuUIToolkitAppTestCase):

    """A common test case class that provides several useful methods for
    clock-app tests.

    """

    local_location = os.path.dirname(os.path.dirname(os.getcwd()))
    local_location_qml = os.path.join(local_location,
                                      'app/ubuntu-clock-app.qml')
    local_location_backend = os.path.join(local_location, 'builddir/backend')
    installed_location_backend = ""
    if glob.glob('/usr/lib/*/qt5/qml/ClockApp'):
        installed_location_backend = \
            glob.glob('/usr/lib/*/qt5/qml/ClockApp')[0]
    installed_location_qml = \
        '/usr/share/ubuntu-clock-app/ubuntu-clock-app.qml'

    # note this directory could change to com.ubuntu.clock at some point
    sqlite_dir = os.path.expanduser(
        "~/.local/share/com.ubuntu.clock")
    backup_dir = sqlite_dir + ".backup"

    def setUp(self):
        # backup and wipe db's before testing
        self.temp_move_sqlite_db()
        self.addCleanup(self.restore_sqlite_db)

        launch, self.test_type = self.get_launcher_method_and_type()
        self.useFixture(fixtures.EnvironmentVariable('LC_ALL', newvalue='C'))
        super(ClockAppTestCase, self).setUp()

        launch()

    def get_launcher_method_and_type(self):
        if os.path.exists(self.local_location_backend):
            launcher = self.launch_test_local
            test_type = 'local'
        elif os.path.exists(self.installed_location_backend):
            launcher = self.launch_test_installed
            test_type = 'deb'
        else:
            launcher = self.launch_test_click
            test_type = 'click'
        return launcher, test_type

    @autopilot_logging.log_action(logger.info)
    def launch_test_local(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.local_location_qml,
            "-I", self.local_location_backend,
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_installed(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.installed_location_qml,
            "-I", self.installed_location_backend,
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_click(self):
        self.app = self.launch_click_package(
            "com.ubuntu.clock.devel",
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def temp_move_sqlite_db(self):
        try:
            shutil.rmtree(self.backup_dir)
        except:
            pass
        else:
            logger.warning("Prexisting backup database found and removed")

        try:
            shutil.move(self.sqlite_dir, self.backup_dir)
        except:
            logger.warning("No current database found")
        else:
            logger.debug("Backed up database")

    def restore_sqlite_db(self):
        if os.path.exists(self.backup_dir):
            if os.path.exists(self.sqlite_dir):
                try:
                    shutil.rmtree(self.sqlite_dir)
                except:
                    logger.error("Failed to remove test database and restore" /
                                 "database")
                    return
            try:
                shutil.move(self.backup_dir, self.sqlite_dir)
            except:
                logger.error("Failed to restore database")

    @property
    def main_view(self):
        return self.app.wait_select_single(emulators.MainView)
