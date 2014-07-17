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

#include <QDebug>
#include <QVariant>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>

#include "alarmsettings.h"

AlarmSettings::AlarmSettings(QObject *parent):
    QObject(parent)
{
    // On startup, retrieve all the settings values from Dbus
    refreshProperties();
}

void AlarmSettings::refreshProperties()
{
    QDBusInterface handlerPropertiesInterface
            ("com.canonical.indicator.datetime",
             "/com/canonical/indicator/datetime/AlarmProperties",
             "org.freedesktop.DBus.Properties");

    QDBusReply<QVariantMap> reply = handlerPropertiesInterface.call
            ("GetAll",
             "com.canonical.indicator.datetime.AlarmProperties");

    if(!reply.isValid()) {
        qWarning() << reply.error();
        return;
    }

    QVariantMap map = reply.value();

    m_volume = map["DefaultVolume"].toInt();
    m_duration = map["Duration"].toInt();
}

void AlarmSettings::setDBusProperty(const QString &name, const QVariant &value)
{
    QDBusInterface handlerPropertiesInterface
            ("com.canonical.indicator.datetime",
             "/com/canonical/indicator/datetime/AlarmProperties",
             "org.freedesktop.DBus.Properties");

    handlerPropertiesInterface.asyncCall(
                "Set",
                "com.canonical.indicator.datetime.AlarmProperties",
                name,
                QVariant::fromValue(QDBusVariant(value)));
}

int AlarmSettings::volume() const
{
    return m_volume;
}

int AlarmSettings::duration() const
{
    return m_duration;
}

void AlarmSettings::setVolume(int volume)
{
    if(m_volume == volume) {
        // Don't send the volume over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_volume = volume;
    emit volumeChanged();

    setDBusProperty("DefaultVolume", QVariant(m_volume));
}

void AlarmSettings::setDuration(int duration)
{
    if(m_duration == duration) {
        // Don't send the duration over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_duration = duration;
    emit durationChanged();

    setDBusProperty("Duration", QVariant(m_duration));
}
