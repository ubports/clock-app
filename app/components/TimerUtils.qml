import QtQuick 2.4

QtObject {

    function get_time_to_alarm(alarmDate, currentDateTime, addSeconds) {
        currentDateTime = currentDateTime ? currentDateTime : new Date();
        // Discard the time and time-zone information, so it will be properly calculate time,
        // even with different timezones (eg. during daylight saving change)
        var totalTime = alarmDate.getTime() -  currentDateTime.getTime();

        var alarmETA = timeDiffToString(totalTime, addSeconds);

        return alarmETA;
    }

    function timeDiffToString(totalTime, addSeconds) {
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
            alarmETA = i18n.tr("%1d %2h %3m")
            .arg(timeObject.days)
            .arg(timeObject.hours)
            .arg(timeObject.minutes)
        }

        // TRANSLATORS: the first argument is the number of
        // hours followed by the minutes (eg. in 4h 3m)
        else if (timeObject.hours) {
            //xgettext: no-c-format
            alarmETA = i18n.tr("%1h %2m")
            .arg(timeObject.hours)
            .arg(timeObject.minutes)

        }

        // TRANSLATORS: the argument is the number of
        // minutes to the alarm (eg. in 3m)
        else {
            //xgettext: no-c-format
            alarmETA = i18n.tr("%1m")
            .arg(timeObject.minutes)

        }

        return alarmETA + (addSeconds ? i18n.tr(" %1s").arg(timeObject.seconds) :"");
    }

    // Function to split time (in ms) into days, hours and minutes
    function _split_time(totalTime) {
        //Fix for flor rounding down 0.999999... numbers
        totalTime+=500;
        var days_in_offset = Math.floor(totalTime / ( 3600000 * 24));
        var hours_in_offset = Math.floor(totalTime / 3600000 % 24);
        var minutes_in_offset = Math.floor(totalTime / 60000 % 60);
        var seconds_in_offset = Math.floor(totalTime / 1000  % 60);

        return {
            days : days_in_offset,
            hours : hours_in_offset,
            minutes : minutes_in_offset,
            seconds : seconds_in_offset
        }
    }
} 
