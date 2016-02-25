/*
 * Copyright (C) 2015-2016 Canonical Ltd
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

#include "formattime.h"

#include <QtMath>

FormatTime::FormatTime(QObject *parent):
    QObject(parent)
{
}

QString FormatTime::millisToString(int millis) const
{
    return addZeroPrefix(QString::number(millis), 3);
}

QString FormatTime::millisToTimeString(int millis, bool showHours) const
{
    int hours, minutes, seconds;

    seconds = qFloor(millis / 1000) % 60;
    minutes = qFloor(millis / 1000 / 60) % 60;
    hours = qFloor(millis / 1000 / 60 / 60);

    QString timeString("");

    if (showHours)
    {
        if (hours < 10)
        {
            timeString += addZeroPrefix(QString::number(hours), 2) + ":";
        }

        else {
            timeString += QString::number(hours) + ":";
        }
    }

    timeString += addZeroPrefix(QString::number(minutes), 2) + ":";
    timeString += addZeroPrefix(QString::number(seconds), 2);

    return timeString;
}

QString FormatTime::addZeroPrefix(QString str, int totalLength) const
{
    return QString("00000" + str).remove(0, 5 + str.length() - totalLength);
}

QString FormatTime::lapTimeToString(int millis) const
{
    return millisToTimeString(millis, true);
}
