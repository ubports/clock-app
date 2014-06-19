/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.1

QtObject {
    id: alarmUtils

    // Function to convert time to 12/24 hour format (Input has to be in 24 hour format)
    function convertTime(hours, minutes, seconds, format) {
        var tempTime = new Date()
        tempTime.setHours(hours, minutes,seconds)
        if (format === "12-hour")
            return Qt.formatTime(tempTime, "h:mm AP")
        else
            return Qt.formatTime(tempTime, "hh:mm")
    }

    function format_day_string(value, type) {
        var occurs = get_day(value, type);
        var WeekDay = 0;
        for (var i = 0; i < Qt.locale().weekDays.length; ++i) {
            switch (Qt.locale().weekDays[i]) {
            case Qt.Monday:
                WeekDay |= Alarm.Monday
                break;
            case Qt.Tuesday:
                WeekDay |= Alarm.Tuesday
                break;
            case Qt.Wednesday:
                WeekDay |= Alarm.Wednesday
                break;
            case Qt.Thursday:
                WeekDay |= Alarm.Thursday
                break;
            case Qt.Friday:
                WeekDay |= Alarm.Friday
                break;
            case Qt.Saturday:
                WeekDay |= Alarm.Saturday
                break;
            case Qt.Sunday:
                WeekDay |= Alarm.Sunday
                break;
            }
        }

        if (value == WeekDay) {
            return i18n.tr("Every weekday")
        }
        else if (value == Alarm.Daily) {
            return i18n.tr("Daily")
        }
        else {
            if (type === Alarm.Repeating)
                return i18n.tr("Every ") + occurs
            else
                return i18n.tr("Once on ")  + occurs
        }
    }

    function get_day(value, type) {
        var occurs = [];
        if (value & Alarm.Monday) occurs.push(Qt.locale().standaloneDayName(1, Locale.ShortFormat));
        if (value & Alarm.Tuesday) occurs.push(Qt.locale().standaloneDayName(2, Locale.ShortFormat));
        if (value & Alarm.Wednesday) occurs.push(Qt.locale().standaloneDayName(3, Locale.ShortFormat));
        if (value & Alarm.Thursday) occurs.push(Qt.locale().standaloneDayName(4, Locale.ShortFormat));
        if (value & Alarm.Friday) occurs.push(Qt.locale().standaloneDayName(5, Locale.ShortFormat));
        if (value & Alarm.Saturday) occurs.push(Qt.locale().standaloneDayName(6, Locale.ShortFormat));
        if (value & Alarm.Sunday) occurs.push(Qt.locale().standaloneDayName(7, Locale.ShortFormat));
        return occurs;
    }
}
