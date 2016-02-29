/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

import QtQuick 2.4
import Ubuntu.Components 1.3

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

    function get_utc_time(dateTime) {
        return new Date(dateTime.getUTCFullYear(),
                        dateTime.getUTCMonth(),
                        dateTime.getUTCDate(),
                        dateTime.getUTCHours(),
                        dateTime.getUTCMinutes(),
                        dateTime.getUTCSeconds(),
                        dateTime.getUTCMilliseconds())
    }

    // Function to format the time to specific alarm into a string
    function get_time_to_alarm(alarmDate, currentDateTime) {
        // Discard the time and time-zone information, so it will be properly calculate time,
        // even with different timezones (eg. during daylight saving change)
        var totalTime = get_utc_time(alarmDate) - get_utc_time(currentDateTime);

        // Alarm has passed
        if(totalTime < 0) {
            return ""
        }

        var timeObject = _split_time(totalTime);
        var alarmETA

        // TRANSLATORS: the first argument is the number of days,
        // followed by hour and minute (eg. in 1d 20h 3m)
        if(timeObject.days) {
            //xgettext: no-c-format
            alarmETA = i18n.tr("in %1d %2h %3m")
            .arg(timeObject.days)
            .arg(timeObject.hours)
            .arg(timeObject.minutes)
        }

        // TRANSLATORS: the first argument is the number of
        // hours followed by the minutes (eg. in 4h 3m)
        else if (timeObject.hours) {
            //xgettext: no-c-format
            alarmETA = i18n.tr("in %1h %2m")
            .arg(timeObject.hours)
            .arg(timeObject.minutes)
        }

        // TRANSLATORS: the argument is the number of
        // minutes to the alarm (eg. in 3m)
        else {
            //xgettext: no-c-format
            alarmETA = i18n.tr("in %1m")
            .arg(timeObject.minutes)
        }

        return alarmETA;
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

    // Function to split time (in ms) into days, hours and minutes
    function _split_time(totalTime) {
        // increase by a minute, so we could make a nicer time
        // to the next alarm, otherwise a minute always missing
        // which makes it look odd
        totalTime += 60000;

        var days_in_offset = Math.floor(totalTime / ( 3600000 * 24));
        var hours_in_offset = Math.floor(totalTime / 3600000 % 24);
        var minutes_in_offset = Math.floor(totalTime / 60000 % 60);

        return {
            days : days_in_offset,
            hours : hours_in_offset,
            minutes : minutes_in_offset
        }
    }

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
            occurs.push(Qt.locale().standaloneDayName(1, Locale.ShortFormat))
        }

        if (value & Alarm.Tuesday) {
            occurs.push(Qt.locale().standaloneDayName(2, Locale.ShortFormat))
        }

        if (value & Alarm.Wednesday) {
            occurs.push(Qt.locale().standaloneDayName(3, Locale.ShortFormat))
        }

        if (value & Alarm.Thursday) {
            occurs.push(Qt.locale().standaloneDayName(4, Locale.ShortFormat))
        }

        if (value & Alarm.Friday) {
            occurs.push(Qt.locale().standaloneDayName(5, Locale.ShortFormat))
        }

        if (value & Alarm.Saturday) {
            occurs.push(Qt.locale().standaloneDayName(6, Locale.ShortFormat))
        }

        if (value & Alarm.Sunday) {
            occurs.push(Qt.locale().standaloneDayName(0, Locale.ShortFormat))
        }

        occurs = occurs.join(', ');

        return occurs;
    }
}
