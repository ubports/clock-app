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
from autopilot.testcase import AutopilotTestCase
import ubuntuuitoolkit
from ubuntuuitoolkit import base

import ubuntu_clock_app
from ubuntu_clock_app import fixture_setup, CMakePluginParser

logger = logging.getLogger(__name__)


class ClockAppTestCase(AutopilotTestCase):

    """A common test case class that provides several useful methods for
    clock-app tests.

    """

    def setUp(self):
        # setup paths
        self.binary = 'ubuntu-clock-app'
        self.source_dir = os.path.dirname(
            os.path.dirname(os.path.abspath('.')))
        self.build_dir = self._get_build_dir()

        self.local_location = self.build_dir
        self.local_location_qml = os.path.join(self.build_dir,
                                          'app', self.binary + '.qml')

        self.local_location_backend = os.path.join(self.local_location,
                                                   'builddir', 'backend')
        self.installed_location_backend = ""
        if glob.glob('/usr/lib/*/qt5/qml/ClockApp'):
            installed_location_backend = \
                glob.glob('/usr/lib/*/qt5/qml/ClockApp')[0]
        self.installed_location_qml = \
            '/usr/share/ubuntu-clock-app/ubuntu-clock-app.qml'

        self.sqlite_dir = os.path.expanduser(
            "~/.local/share/com.ubuntu.clock")
        self.backup_dir = self.sqlite_dir + ".backup"


        # backup and wipe db's before testing
        self.temp_move_sqlite_db()
        self.addCleanup(self.restore_sqlite_db)

        # setup fixtures and launcher
        self.useFixture(fixture_setup.LocationServiceTestEnvironment())
        self.useFixture(fixtures.EnvironmentVariable('LC_ALL', newvalue='C'))
        self.launcher, self.test_type = self.get_launcher_and_type()

        # launch application under introspection
        super(ClockAppTestCase, self).setUp()
        self.app = ubuntu_clock_app.ClockApp(self.launcher(), self.test_type)


    def get_launcher_and_type(self):
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
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_installed(self):
        self.app = self.launch_test_application(
            base.get_qmlscene_launch_command(),
            self.installed_location_qml,
            "-I", self.installed_location_backend,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_click(self):
        self.app = self.launch_click_package(
            "com.ubuntu.clock",
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

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

    def _get_build_dir(self):
        """
        Returns the build dir after having parsed the CMake config file
        generated by Qt Creator. If it cannot find it or it cannot be parsed,
        an in-tree build is assumed and thus returned.
        """
        try:
            cmake_config = CMakePluginParser.CMakePluginParser(os.path.join(
                self.source_dir, 'CMakeLists.txt.user'))
            build_dir = cmake_config.active_build_dir
        except:
            build_dir = self.source_dir

        return build_dir
