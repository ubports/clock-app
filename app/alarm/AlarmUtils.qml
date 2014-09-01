/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.3
import Ubuntu.Components 1.1

/*
  Qt Object containing a collection of useful alarm functions
*/
QtObject {
    id: alarmUtils

    // Function to format the alarm days accordingly to their occurance
    function format_day_string(value, type) {
        if (type === Alarm.OneTime) {
            return i18n.tr("Never")
        }

        var occurs = _get_day(value)

        if (value === _get_weekdays()) {
            return i18n.tr("Weekdays")
        }

        else if (value === _get_weekends()) {
            return i18n.tr("Weekends")
        }

        else if (value === Alarm.Daily) {
            return i18n.tr("Daily")
        }

        else {
            return occurs
        }
    }

    // Function return the alarm dayOfWeek according to the day provided
    function get_alarm_day(day) {
        switch(day) {
        case 0: return Alarm.Sunday
        case 1: return Alarm.Monday
        case 2: return Alarm.Tuesday
        case 3: return Alarm.Wednesday
        case 4: return Alarm.Thursday
        case 5: return Alarm.Friday
        case 6: return Alarm.Saturday
        }
    }

    /*
      INTERNAL FUNCTIONS
    */

    // Function to determine the locale's weekdays value
    function _get_weekdays() {
        var weekDays = 0
        for (var i = 0; i < Qt.locale().weekDays.length; ++i) {
            switch (Qt.locale().weekDays[i]) {
            case Qt.Monday: {
                weekDays |= Alarm.Monday
                break
            }

            case Qt.Tuesday: {
                weekDays |= Alarm.Tuesday
                break
            }

            case Qt.Wednesday: {
                weekDays |= Alarm.Wednesday
                break
            }

            case Qt.Thursday: {
                weekDays |= Alarm.Thursday
                break
            }

            case Qt.Friday: {
                weekDays |= Alarm.Friday
                break
            }

            case Qt.Saturday: {
                weekDays |= Alarm.Saturday
                break
            }

            case Qt.Sunday: {
                weekDays |= Alarm.Sunday
                break
            }
            }
        }
        return weekDays
    }

    // Function to determine the locale's weekends value
    function _get_weekends() {
        return (Alarm.Daily - _get_weekdays())
    }

    // Function to retrieve the days of the week in the locale system
    function _get_day(value) {
        var occurs = []

        if (value & Alarm.Monday) {
            occurs.push(Qt.locale().standaloneDayName(1, Locale.LongFormat))
        }

        if (value & Alarm.Tuesday) {
            occurs.push(Qt.locale().standaloneDayName(2, Locale.LongFormat))
        }

        if (value & Alarm.Wednesday) {
            occurs.push(Qt.locale().standaloneDayName(3, Locale.LongFormat))
        }

        if (value & Alarm.Thursday) {
            occurs.push(Qt.locale().standaloneDayName(4, Locale.LongFormat))
        }

        if (value & Alarm.Friday) {
            occurs.push(Qt.locale().standaloneDayName(5, Locale.LongFormat))
        }

        if (value & Alarm.Saturday) {
            occurs.push(Qt.locale().standaloneDayName(6, Locale.LongFormat))
        }

        if (value & Alarm.Sunday) {
            occurs.push(Qt.locale().standaloneDayName(0, Locale.LongFormat))
        }

        occurs = occurs.join(', ');

        return occurs;
    }
}
