# -#- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -#-
#
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

import logging

from autopilot import logging as autopilot_logging
from autopilot.introspection import dbus
from testtools.matchers import GreaterThan

from ubuntuuitoolkit import (
    MainView, UbuntuUIToolkitCustomProxyObjectBase, pickers, UCListItem)
import ubuntuuitoolkit

logger = logging.getLogger(__name__)


class ClockEmulatorException(ubuntuuitoolkit.ToolkitException):
    """Exception raised when there is an error with the emulator."""


class ClockApp(object):
    """Autopilot helper object for clock."""

    def __init__(self, app_proxy, test_type):
        self.app = app_proxy
        self.test_type = test_type
        # Use only objectName due to bug 1350532 as it is MainView12
        self.main_view = self.app.wait_select_single(
            objectName="clockMainView")

    @property
    def pointing_device(self):
        return self.app.pointing_device


class MainView(MainView):

    @autopilot_logging.log_action(logger.info)
    def open_clock(self):
        """Open the Clock Page.

        :return the Clock Page

        """
        return self.wait_select_single(ClockPage)

    @autopilot_logging.log_action(logger.info)
    def open_alarm(self):
        """Open the Alarm Page.

        :return: the Alarm Page.

        """
        mainPage = self.get_main_page()
        mainPage.reveal_bottom_edge_page()
        return self.wait_select_single(AlarmPage)

    def get_AlarmList(self):
        """ Get the AlarmList object. """
        return AlarmList.select(self)

    def get_main_page(self):
        return self.wait_select_single(MainPage, objectName="mainPage")

    @autopilot_logging.log_action(logger.info)
    def get_worldCityList(self):
        """ Return the World City List page """
        return self.wait_select_single("WorldCityList",
                                       objectName="worldCityList")


class Page(UbuntuUIToolkitCustomProxyObjectBase):
    """Autopilot helper for Pages."""

    def __init__(self, *args):
        super(Page, self).__init__(*args)
        # XXX we need a better way to keep reference to the main view.
        # --elopio - 2014-01-31

        # Use only objectName due to bug 1350532 as it is MainView12
        self.main_view = self.get_root_instance().select_single(
            objectName="clockMainView")


class MainPage(Page):
    """Autopilot helper for the Main page."""

    def reveal_bottom_edge_page(self):
        """Bring the bottom edge page to the screen"""
        try:
            bottom_edge_hint = self.wait_select_single(
                "UCBottomEdgeHint", objectName="bottomEdgeHint")
            bottom_edge_hint.visible.wait_for(True)
            start_x = (bottom_edge_hint.globalRect.x +
                       (bottom_edge_hint.globalRect.width * 0.5))
            start_y = (bottom_edge_hint.globalRect.y +
                       (bottom_edge_hint.height * 0.5))
            stop_y = start_y - (self.height * 0.7)
            self.pointing_device.drag(start_x, start_y,
                                      start_x, stop_y, rate=2)
            bottom_edge = self.wait_select_single(
                "AlarmBottomEdge", objectName="bottomEdge")
            bottom_edge.status.wait_for(2)
        except dbus.StateNotFoundError:
            logger.error('BottomEdge element not found.')
            raise


class ClockPage(Page):
    """Autopilot helper for the Clock page."""

    @autopilot_logging.log_action(logger.info)
    def click_addCity_to_open_worldCityList(self):
        """Swipe to reveal WorldCityList"""
        addWorldCityButton = self.wait_select_single(
            "UCAbstractButton", objectName="addWorldCityButton")
        self.pointing_device.click_object(addWorldCityButton)

    def get_num_of_saved_cities(self):
        """Return the number of saved world cities"""
        return int(self._get_saved_world_city_list().count)

    def _get_saved_world_city_list(self):
        """Return the saved world city listview object"""
        return self.wait_select_single(
            "QQuickListView", objectName='userWorldCityRepeater')

    @autopilot_logging.log_action(logger.info)
    def delete_added_world_city(self, city_Name, country_Name):
        """ Delete added world city from user world city list """
        old_cities_count = self.get_num_of_saved_cities()
        index = 0
        for index in range(old_cities_count):
            world_city_item = self.wait_select_single(
                objectName='userWorldCityItem{}'.format(index))
            city_name_label = world_city_item.wait_select_single(
                'UCLabel', objectName='userCityNameText')
            country_name_label = world_city_item.wait_select_single(
                'UCLabel', objectName='userCountryNameText')
            if (city_name_label.text == city_Name and
                    country_name_label.text == country_Name):
                self._delete_userWorldCityItem(index)

    # FIXME -----------------------------------------------------------------
    # Commenting the following lines as deleting a world city when there is
    # only one in the user world city list does not decrease counter to 0 but
    # leaves it at 1 so the test fails
    # Reported bug #1368393
    # Discovered that deleting world city clock deletes the city from the clock
    # app, but if you look with autopilot vis the world city is still there
    # added a comment to bug #1368393
    #
    #    try:
    #        self._get_saved_world_city_list().count.wait_for(
    #            old_cities_count - 1)
    #    except AssertionError:
    #        raise ClockEmulatorException('Error deleting city.')
    # -------------------------------------------------------------------------

    def _delete_userWorldCityItem(self, index):
        cityItem = self.wait_select_single(
            objectName='userWorldCityItem{}'.format(index))
        cityItem.click_remove_action()


class UserWorldCityDelegate(UCListItem):
    """Autopilot helper for user world city delegate"""

    def click_remove_action(self):
        return self.trigger_leading_action('swipeDeleteAction',
                                           self.wait_until_destroyed)


class AlarmPage(Page):
    """Autopilot helper for the Alarm page."""

    @autopilot_logging.log_action(logger.info)
    def add_single_alarm(self, name, days, time_to_set, test_sound_name):
        """Add a single type alarm

        :param name: name of alarm
        :param days: days on which the alarm should be triggered
        :param time_to_set: time to set alarm to
        :param test_sound_name: sound to set in alarm

        """
        alarmListPage = AlarmList.select(self.main_view)
        old_alarm_count = alarmListPage.get_num_of_alarms()

        edit_alarm_page = self._click_add_alarm_button()
        edit_alarm_page.set_alarm_time(time_to_set)

        alarm_repeat_page = edit_alarm_page.open_alarmRepeat_page()
        alarm_repeat_page.set_alarm_days(days)
        alarm_repeat_page.click_save_button()

        alarm_label_page = edit_alarm_page.open_alarmLabel_page()
        alarm_label_page.set_alarm_label(name)
        alarm_label_page.click_save_button()

        alarm_sound_page = edit_alarm_page.open_alarmSound_page()
        alarm_sound_page.set_alarm_sound(test_sound_name)
        alarm_sound_page.click_save_button()

        edit_alarm_page._check_sound_changed(test_sound_name)
        edit_alarm_page._click_save_alarm_button()
        self._confirm_alarm_creation(old_alarm_count)

    def _click_add_alarm_button(self):
        """Click the add alarm header button."""
        addHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="addAlarmAction_button")
        self.pointing_device.click_object(addHeaderButton)
        return self.main_view.wait_select_single(EditAlarmPage)

    def _confirm_alarm_creation(self, count):
        """Confirm creation of alarm

        :param count: alarm count before alarm creation

        """
        try:
            AlarmList.select(self.main_view)._get_saved_alarms_list().\
                count.wait_for(count + 1)
        except AssertionError:
            raise ClockEmulatorException('Error creating alarm.')


class WorldCityList(Page):
    """Autopilot helper for World City List page."""

    @autopilot_logging.log_action(logger.info)
    def add_world_city_from_list(self, city_Name, country_Name):
        """Add world city from list

        :param city_Name: world city name to add
        :param country_Name: country city name belongs to (same city name could
         be found in more countries)
        """
        self.wait_select_single("ActivityIndicator").running.wait_for(False)
        cityList = self.wait_select_single("QQuickListView",
                                           objectName="cityList")

        cityList.count.wait_for(GreaterThan(0))

        # Debug line
        # cityList.print_tree()

        for index in range(int(cityList.count)):
            world_city_item = self.wait_select_single(
                objectName='defaultWorldCityItem{}'.format(index))
            city_name_label = world_city_item.wait_select_single(
                'UCLabel', objectName='defaultCityNameText')
            country_name_label = world_city_item.wait_select_single(
                'UCLabel', objectName='defaultCountryNameText')
            if (city_name_label.text == city_Name and
                    country_name_label.text == country_Name):
                cityList.click_element(
                    'defaultWorldCityItem{}'.format(index), direction=None)
                break

    @autopilot_logging.log_action(logger.info)
    def search_world_city_(self, city_Name, country_Name):
        """Add world city by searching the world city name

        :param city_Name: world city name to add

        """
        searchHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="searchButton_button")
        self.pointing_device.click_object(searchHeaderButton)
        self._search_world_city(city_Name, country_Name)

    def _search_world_city(self, city_Name, country_Name):
        searchTextfield = self.wait_select_single(
            "TextField", objectName='searchField')
        searchTextfield.visible.wait_for(True)
        searchTextfield.write(city_Name)


class EditAlarmPage(Page):
    """Autopilot helper for the Add Alarm page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_time(self, time_to_set):
        """Set alarm time on datepicker.

        :param time_to_set: time to set on datepicker

        """
        PickerRow_HoursPicker = self.wait_select_single(
            "Picker", objectName="PickerRow_HoursPicker")
        self._set_picker(PickerRow_HoursPicker, 'time', time_to_set)

    def _set_picker(self, field, mode, value):
        # open picker
        self.pointing_device.click_object(field)
        # valid options are date or time; assume date if invalid/no option
        mode_value = 'Hours|Minutes'
        picker = self.wait_select_single(
            pickers.DatePicker, mode=mode_value, visible=True)
        picker.pick_time(value)
        # close picker
        self.pointing_device.click_object(field)

    @autopilot_logging.log_action(logger.info)
    def open_alarmRepeat_page(self):
        """ Open the alarmRepeat page """

        alarmRepeatItem = self.wait_select_single(
            "UCListItem", objectName="alarmRepeat")
        self.pointing_device.click_object(alarmRepeatItem)
        return self.main_view.wait_select_single(AlarmRepeat)

    @autopilot_logging.log_action(logger.info)
    def open_alarmLabel_page(self):
        """ Open the alarmLabel page """

        alarmLabelItem = self.wait_select_single(
            "UCListItem", objectName="alarmLabel")
        self.pointing_device.click_object(alarmLabelItem)
        return self.main_view.wait_select_single(AlarmLabel)

    @autopilot_logging.log_action(logger.info)
    def open_alarmSound_page(self):
        """ Open the alarmSound page """

        alarmSoundItem = self.wait_select_single(
            "UCListItem", objectName="alarmSound")
        self.pointing_device.click_object(alarmSoundItem)
        return self.main_view.wait_select_single(AlarmSound)

    def _check_sound_changed(self, test_sound_name):
        """ function to check that sound has changed.

        :param test_sound_name = new sound name

        """
        try:
            alarmSoundItem = self.wait_select_single(
                "UCListItem", objectName="alarmSound")
            alarmSoundItem.wait_select_single(
                "UCLabel", objectName="soundName").text.wait_for(
                    test_sound_name)
        except AssertionError:
            raise ClockEmulatorException('Error! Incorrect alarm sound')

    def _click_save_alarm_button(self):
        """Click the save timer header button"""
        saveHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="saveAlarmAction_button")
        self.pointing_device.click_object(saveHeaderButton)


class AlarmRepeat(Page):
    """Autopilot helper for the  AlarmRepeat page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_days(self, days):
        """Set the alarm days of the alarm.

        :param days: days on which alarm is triggered

        """
        self.unselect_selected_days()
        index = 0

        # Debug line
        # self.print_tree()

        for index in range(len(days)):
            for index2 in range(self._get_num_of_days()):
                alarm_day_item = self.wait_select_single(
                    objectName='alarmDayHolder{}'.format(index2))
                if alarm_day_item.wait_select_single(
                        'UCLabel', objectName='alarmDay').text\
                        == days[index]:
                    self._select_single_alarm_day(index2)
                    break

    def _get_num_of_days(self):
        return int(self.wait_select_single(
            'QQuickRepeater', objectName='alarmDays').count)

    def _select_single_alarm_day(self, index):
        """ function for selecting the day passed to the function.

        :param index: the day to be selected

        """
        alarm_day_item = self.wait_select_single(
            objectName='alarmDayHolder{}'.format(index))
        dayCheckbox = alarm_day_item.wait_select_single(
            'CheckBox', objectName='daySwitch')
        dayCheckbox.check()

    def click_save_button(self):
        saveHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="saveAction_button")
        self.pointing_device.click_object(saveHeaderButton)

    @autopilot_logging.log_action(logger.info)
    def unselect_selected_days(self):
        """ function for unselecting already selected days.   """
        for index in range(self._get_num_of_days()):
            alarm_day_item = self.wait_select_single(
                objectName='alarmDayHolder{}'.format(index))
            dayCheckbox = alarm_day_item.wait_select_single(
                'CheckBox', objectName='daySwitch')
            dayCheckbox.uncheck()


class AlarmSound(Page):
    """Autopilot helper for the  AlarmSound page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_sound(self, test_sound_name):
        """Set alarm sound.

        :param test_sound_name: sound to set for alarm

        """
        for index in range(self._get_num_of_sounds()):
            alarm_sound_item = self.wait_select_single(
                objectName='alarmSoundDelegate{}'.format(index))
            if alarm_sound_item.wait_select_single(
                    'UCLabel', objectName='soundName').\
                    text == test_sound_name:
                self._select_alarm_sound(index)
                break

    def _get_num_of_sounds(self):
        return int(self.wait_select_single(
            'QQuickRepeater', objectName='alarmSounds').count)

    def _select_alarm_sound(self, index):
        """ function for selecting the sound passed to the function.

        :param index: the sound to be selected

        """
        alarm_sound_item = self.wait_select_single(
                objectName='alarmSoundDelegate{}'.format(index))
        self.pointing_device.click_object(alarm_sound_item)

    def click_save_button(self):
        saveHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="saveAction_button")
        self.pointing_device.click_object(saveHeaderButton)


class AlarmLabel(Page):
    """Autopilot helper for the  AlarmLabel page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_label(self, name):
        """Set alarm label.

        :param name: label for alarm to set

        """
        alarmTextfield = self.wait_select_single(
            "TextField", objectName='labelEntry')
        # TODO: This wait to ensure that the textfield is visible before
        # entering text should be part of the SDK emulator. Until then, it has
        # been added here. http://pad.lv/1289616  --nik90 2014-03-06
        alarmTextfield.visible.wait_for(True)
        alarmTextfield.write(name)

    def click_save_button(self):
        saveHeaderButton = self.wait_select_single(
            "UCAbstractButton", objectName="saveAction_button")
        self.pointing_device.click_object(saveHeaderButton)


class AlarmList(object):
    """Autopilot helper for the  AlarmList."""

    def __init__(self, proxy_object):
        super(AlarmList, self).__init__()
        self.proxy_object = proxy_object

    @classmethod
    def select(cls, main_view):
        proxy_object = main_view.wait_select_single(
            'AlarmList', objectName='alarmListView')
        proxy_object.visible.wait_for(True)
        return cls(proxy_object)

    def get_num_of_alarms(self):
        """Return the number of saved alarms."""
        return int(self._get_saved_alarms_list().count)

    def _get_saved_alarms_list(self):
        """Return the saved alarm list"""
        return self.proxy_object

    def get_saved_alarms(self):
        """Return a list with the information of the saved alarms.

        Each item of the returned list is a tuple of
        (name, recurrence, time, enabled).

        """
        alarms = []
        for index in range(self.get_num_of_alarms()):
            alarm_item = self.proxy_object.wait_select_single(
                 objectName='alarm{}'.format(index))
            name = alarm_item.wait_select_single(
                'UCLabel', objectName='alarmName').text
            recurrence = alarm_item.wait_select_single(
                'UCLabel', objectName='alarmOccurrence').text
            time = alarm_item.wait_select_single(
                'UCLabel', objectName='alarmTime').text
            enabled = alarm_item.wait_select_single(
                ubuntuuitoolkit.CheckBox,
                objectName='listAlarmStatus').checked
            alarms.append((name, recurrence, enabled, time))
        return alarms

    @autopilot_logging.log_action(logger.info)
    def delete_alarm(self, index):
        """Delete an alarm at the specified index."""
        old_alarm_count = self.get_num_of_alarms()
        alarm = self.proxy_object.wait_select_single(
            objectName='alarm{}'.format(index))

        alarm.click_remove_action()
        try:
            self._get_saved_alarms_list().count.wait_for(old_alarm_count - 1)
        except AssertionError:
            raise ClockEmulatorException('Error deleting alarm.')


class AlarmDelegate(UCListItem):
    """Autopilot helper for alarm delegate"""

    def click_remove_action(self):
        return self.trigger_leading_action('deleteAction',
                                           self.wait_until_destroyed)
