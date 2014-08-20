# -#- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -#-
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

import logging

from autopilot import logging as autopilot_logging
from autopilot.introspection import dbus

from ubuntuuitoolkit import pickers
import ubuntuuitoolkit

logger = logging.getLogger(__name__)


class ClockEmulatorException(ubuntuuitoolkit.ToolkitException):

    """Exception raised when there is an error with the emulator."""


class MainView(ubuntuuitoolkit.MainView):

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
        clockPage = self.open_clock()
        clockPage.reveal_bottom_edge_page()
        self.get_header().visible.wait_for(True)
        return self.wait_select_single(Page11)

    def get_AlarmList(self):
        """ Get the AlarmList object. """
        return AlarmList.select(self)


class Page(ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase):

    """Autopilot helper for Pages."""

    def __init__(self, *args):
        super(Page, self).__init__(*args)
        # XXX we need a better way to keep reference to the main view.
        # --elopio - 2014-01-31
        self.main_view = self.get_root_instance().select_single(MainView)


class PageWithBottomEdge(MainView):
    """
    An emulator class that makes it easy to interact with the bottom edge
    swipe page
    """
    def __init__(self, *args):
        super(PageWithBottomEdge, self).__init__(*args)

    def reveal_bottom_edge_page(self):
        """Bring the bottom edge page to the screen"""
        self.bottomEdgePageLoaded.wait_for(True)
        try:
            action_item = self.wait_select_single(objectName='bottomEdgeTip')
            start_x = (action_item.globalRect.x +
                       (action_item.globalRect.width * 0.5))
            start_y = (action_item.globalRect.y +
                       (action_item.height * 0.5))
            stop_y = start_y - (self.height * 0.7)
            self.pointing_device.drag(start_x, start_y,
                                      start_x, stop_y, rate=2)
            self.isReady.wait_for(True)
        except dbus.StateNotFoundError:
            logger.error('BottomEdge element not found.')
            raise


class ClockPage(PageWithBottomEdge):
    """Autopilot helper for the Clock page."""


class Page11(Page):
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
        self._click_header_backButton()

        alarm_label_page = edit_alarm_page.open_alarmLabel_page()
        alarm_label_page.set_alarm_label(name)
        self._click_header_customBackButton()

        alarm_sound_page = edit_alarm_page.open_alarmSound_page()
        alarm_sound_page.set_alarm_sound(test_sound_name)
        self._click_header_customBackButton()
        edit_alarm_page._check_sound_changed(test_sound_name)

        self._click_save()
        self._confirm_alarm_creation(old_alarm_count)

    def _click_add_alarm_button(self):
        """Click the add alarm header button."""
        header = self.main_view.get_header()
        header.click_action_button('addAlarmAction')
        return self.main_view.wait_select_single(EditAlarmPage)

    def _click_header_customBackButton(self):
        """Click the  header button:  'customBackButton' """
        header = self.main_view.get_header()
        header.click_custom_back_button()

    def _click_header_backButton(self):
        """Click the  header button:  'backButton' """
        header = self.main_view.get_header()
        header.click_back_button()

    def _click_save(self):
        """Click the save timer header button"""
        header = self.main_view.get_header()
        header.click_action_button('saveAlarmAction')

    def _confirm_alarm_creation(self, count):
        """Confirm creation of alarm

        :param count: alarm count before alarm creation

        """
        try:
            AlarmList.select(self.main_view)._get_saved_alarms_list().\
                count.wait_for(count + 1)
        except AssertionError:
            raise ClockEmulatorException('Error creating alarm.')


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
            "SubtitledListItem", objectName="alarmRepeat")
        self.pointing_device.click_object(alarmRepeatItem)
        return self.main_view.wait_select_single(AlarmRepeat)

    @autopilot_logging.log_action(logger.info)
    def open_alarmLabel_page(self):
        """ Open the alarmLabel page """

        alarmLabelItem = self.wait_select_single(
            "SubtitledListItem", objectName="alarmLabel")
        self.pointing_device.click_object(alarmLabelItem)
        return AlarmLable.select(self.main_view)

    @autopilot_logging.log_action(logger.info)
    def open_alarmSound_page(self):
        """ Open the alarmSound page """

        alarmSoundItem = self.wait_select_single(
            "SubtitledListItem", objectName="alarmSound")
        self.pointing_device.click_object(alarmSoundItem)
        return self.main_view.wait_select_single(AlarmSound)

    def _check_sound_changed(self, test_sound_name):
        """ function to check that sound has changed.

        :param test_sound_name = new sound name

        """
        try:
            self.wait_select_single(
                "SubtitledListItem", objectName="alarmSound").subText.wait_for(
                    test_sound_name)
        except AssertionError:
            raise ClockEmulatorException('Error! Incorrect alarm sound')


class AlarmRepeat(Page):
    """Autopilot helper for the  AlarmRepeat page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_days(self, days):
        """Set the alarm days of the alarm.

        :param days: days on which alarm is triggered

        """
        self.unselect_selected_days()
        index = 0
        for index in range(len(days)):
            for index2 in range(self._get_num_of_days()):
                if self.wait_select_single(
                        'Label', objectName='alarmDay{}'.format(index2)).text\
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
        dayCheckbox = self.wait_select_single(
            'CheckBox', objectName='daySwitch{}'.format(index))
        dayCheckbox.check()

    @autopilot_logging.log_action(logger.info)
    def unselect_selected_days(self):
        """ function for unselecting already selected days.   """
        for index in range(self._get_num_of_days()):
            dayCheckbox = self.wait_select_single(
                'CheckBox', objectName='daySwitch{}'.format(index))
            dayCheckbox.uncheck()


class AlarmSound(Page):
    """Autopilot helper for the  AlarmSound page."""

    @autopilot_logging.log_action(logger.info)
    def set_alarm_sound(self, test_sound_name):
        """Set alarm sound.

        :param test_sound_name: sound to set for alarm

        """
        for index in range(self._get_num_of_sounds()):
            if self.wait_select_single(
                    'Label', objectName='soundName{}'.format(index)).\
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
        soundCheckbox = self.wait_select_single(
            'CheckBox', objectName='soundStatus{}'.format(index))
        soundCheckbox.check()


class AlarmLable(object):
    """Autopilot helper for the  AlarmLabel page."""

    def __init__(self, proxy_object):
        super(AlarmLable, self).__init__()
        self.proxy_object = proxy_object

    @classmethod
    def select(cls, main_view):
        proxy_object = main_view.wait_select_single(
            objectName='alarmLabelPage')
        proxy_object.visible.wait_for(True)
        return cls(proxy_object)

    @autopilot_logging.log_action(logger.info)
    def set_alarm_label(self, name):
        """Set alarm label.

        :param name: label for alarm to set

        """
        alarmTextfield = self.proxy_object.wait_select_single(
            "TextField", objectName='labelEntry')
        # TODO: This wait to ensure that the textfield is visible before
        # entering text should be part of the SDK emulator. Until then, it has
        # been added here. http://pad.lv/1289616  --nik90 2014-03-06
        alarmTextfield.visible.wait_for(True)
        alarmTextfield.write(name)


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
            name = self.proxy_object.wait_select_single(
                'Label', objectName='listAlarmLabel{}'.format(index)).text
            recurrence = self.proxy_object.wait_select_single(
                'Label', objectName='listAlarmSubtitle{}'.format(index)).text
            time = self.proxy_object.wait_select_single(
                'Label', objectName='listAlarmTime{}'.format(index)).text
            enabled = self.proxy_object.wait_select_single(
                ubuntuuitoolkit.CheckBox,
                objectName='listAlarmStatus{}'.format(index)).checked
            alarms.append((name, recurrence, enabled, time))
        return alarms

    @autopilot_logging.log_action(logger.info)
    def delete_alarm(self, index):
        """Delete an alarm at the specified index."""
        old_alarm_count = self.get_num_of_alarms()
        alarm = self.proxy_object.wait_select_single(
            objectName='alarm{}'.format(index))

        alarm.swipe_to_delete()
        alarm.confirm_removal()
        try:
            self._get_saved_alarms_list().count.wait_for(old_alarm_count - 1)
        except AssertionError:
            raise ClockEmulatorException('Error deleting alarm.')


class ListItemWithActions(
        ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase):

    def swipe_to_delete(self):
        x, y, width, height = self.globalRect
        start_x = x + (width * 0.2)
        stop_x = x + (width * 0.8)
        start_y = stop_y = y + (height // 2)

        self.pointing_device.drag(start_x, start_y, stop_x, stop_y)

    def confirm_removal(self):
        deleteButton = self.wait_select_single(name='delete')
        self.pointing_device.click_object(deleteButton)
