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
#include <QVariant>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>

#include "alarmsettings.h"

AlarmSettings::AlarmSettings(QObject *parent):
    QObject(parent)
{
    testOutput();
}

void AlarmSettings::testOutput()
{
    QDBusInterface handlerPropertiesInterface("com.canonical.indicator.datetime.AlarmProperties",
                                              "/com/canonical/indicator/datetime/AlarmProperties",
                                              "org.freedesktop.DBus.Properties");

    QDBusReply<QString> reply =
            handlerPropertiesInterface.call("Get",
                                            "com.canonical.indicator.datetime.AlarmProperties",
                                            "DefaultSound");

    if(!reply.isValid()) {
        qWarning() << reply.error();
        return;
    }

    qDebug() << reply.value();

//    QVariantMap map = reply.value();
//    qDebug() << map;
//    m_volume = map["DefaultVolume"].toUInt();
//    emit volumeChanged();

//    qDebug() << m_volume;
}

int AlarmSettings::volume() const
{
    return m_volume;
}

int AlarmSettings::duration() const
{
    return m_duration;
}

void AlarmSettings::setVolume(const int &volume)
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

void AlarmSettings::setDuration(const int &duration)
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
