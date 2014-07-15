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

#include <QDebug>

#include "alarmsettings.h"

AlarmSettings::AlarmSettings(QObject *parent):
    QObject(parent)
{
}

void AlarmSettings::testOutput(const QString &test)
{
    qDebug() << "LOG: " + test;
}

unsigned int AlarmSettings::volume() const
{
    return m_volume;
}

unsigned int AlarmSettings::duration() const
{
    return m_duration;
}

void AlarmSettings::setVolume(const unsigned int &volume)
{
    if(m_volume == volume) {
        // Don't send the volume over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_volume = volume;
    emit volumeChanged();

    /*
     TODO: Send the volume over dbus
    */
}

void AlarmSettings::setDuration(const unsigned int &duration)
{
    if(m_duration == duration) {
        // Don't send the duration over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_duration = duration;
    emit durationChanged();

    /*
     TODO: Send the duration over dbus
    */
}
