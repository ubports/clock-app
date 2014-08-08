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
import logging
import fixtures

from autopilot import input
from autopilot.platform import model
from ubuntuuitoolkit import (
    base,
    emulators as toolkit_emulators
)

from ubuntu_clock_app import emulators

logger = logging.getLogger(__name__)


def find_local_path(what):

    """Depending on which directory we build in, paths might be
    named differently. This way we find them and don't have to
    hook into cmake variables.

    """
    if not what:
        return None
    if what.endswith("/"):
        what = what[:-1]
    for dirpath, dirnames, filenames in os.walk("../.."):
        avail_dirs = map(lambda a: os.path.abspath(os.path.join(dirpath, a)),
                         dirnames)
        match_dirs = filter(lambda a: a.endswith(what), avail_dirs)
        if match_dirs:
            return match_dirs[0]

        avail_files = map(lambda a: os.path.abspath(os.path.join(dirpath, a)),
                          filenames)
        match_files = filter(lambda a: a.endswith(what), avail_files)
        if match_files:
            return match_files[0]
    return None


class ClockAppTestCase(base.UbuntuUIToolkitAppTestCase):

    """A common test case class that provides several useful methods for
    clock-app tests.

    """
    local_location = find_local_path("app/ubuntu-clock-app.qml")
    local_backend_dir = find_local_path("backend/")
    installed_location = "/usr/share/ubuntu-clock-app/app/ubuntu-clock-app.qml"
    # FIXME: this is hard-coded ('builddir') and needs to be the actual path.
    installed_backend_dir = "/usr/share/ubuntu-clock-app/builddir/backend/"
    sqlite_dir = os.path.expanduser(
        "~/.local/share/com.ubuntu.clock")
    backup_dir = sqlite_dir + ".backup"

    def setUp(self):
        super(ClockAppTestCase, self).setUp()
        self.pointing_device = input.Pointer(self.input_device_class.create())

        self.useFixture(fixtures.EnvironmentVariable('LC_ALL', newvalue='C'))

        # backup and wipe db's before testing
        self.temp_move_sqlite_db()
        self.addCleanup(self.restore_sqlite_db)

        # turn off the OSK so it doesn't block screen elements
        if model() != 'Desktop':
            os.system("stop maliit-server")
            self.addCleanup(os.system, "start maliit-server")

        if os.path.exists(self.local_location):
            self.launch_test_local()
        elif os.path.exists(self.installed_location):
            self.launch_test_installed()
        else:
            self.launch_test_click()

    def launch_test_local(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.local_location,
            "-I", self.local_backend_dir,
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def launch_test_installed(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.installed_location,
            "-I", self.installed_backend_dir,
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

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
