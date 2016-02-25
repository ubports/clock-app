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

#include <QDebug>
#include <QtDBus>

#include "settings.h"

Settings::Settings(QObject *parent):
    QObject(parent)
{
    // On startup, retrieve all the settings values from Dbus
    refreshProperties();

    // Listen to property changes signal being triggered on the Dbus side
    QDBusConnection connection = QDBusConnection::sessionBus();
    connection.connect("com.canonical.indicator.datetime",
                       "/com/canonical/indicator/datetime/AlarmProperties",
                       "org.freedesktop.DBus.Properties",
                       "PropertiesChanged",
                       this,
                       SLOT(onSettingsChanged(QString, QVariantMap, QStringList)));
}

void Settings::onSettingsChanged(const QString &interface,
                                      const QVariantMap &properties,
                                      const QStringList & /*valid*/)
{
    if(interface != "com.canonical.indicator.datetime.AlarmProperties") {
        // Check if the properties changed are in the correct interface
        return;
    }

    auto it = properties.find("DefaultVolume");

    if (it != properties.end()) {
        const int volume = it.value().toInt();
        if (m_volume != volume) {
            m_volume = volume;
            emit volumeChanged();
        }
    }

    it = properties.find("Duration");

    if (it != properties.end()) {
        const int duration = it.value().toInt();
        if (m_duration != duration) {
            m_duration = duration;
            emit durationChanged();
        }
    }

    it = properties.find("SnoozeDuration");

    if (it != properties.end()) {
        const int snoozeDuration = it.value().toInt();
        if (m_snoozeDuration != snoozeDuration) {
            m_snoozeDuration = snoozeDuration;
            emit snoozeDurationChanged();
        }
    }

    it = properties.find("HapticFeedback");

    if (it != properties.end()) {
        const QString vibration = it.value().toString();
        if (m_vibration != vibration) {
            m_vibration = vibration;
            emit vibrationChanged();
        }
    }
}

void Settings::refreshProperties()
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
    m_snoozeDuration = map["SnoozeDuration"].toInt();
    m_vibration = map["HapticFeedback"].toString();
}

void Settings::setDBusProperty(const QString &name, const QVariant &value)
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

int Settings::volume() const
{
    return m_volume;
}

int Settings::duration() const
{
    return m_duration;
}

int Settings::snoozeDuration() const
{
    return m_snoozeDuration;
}

QString Settings::vibration() const
{
    return m_vibration;
}

void Settings::setVolume(int volume)
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

void Settings::setDuration(int duration)
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

void Settings::setSnoozeDuration(int snoozeDuration)
{
    if(m_snoozeDuration == snoozeDuration) {
        // Don't send the snooze duration over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_snoozeDuration = snoozeDuration;
    emit snoozeDurationChanged();

    setDBusProperty("SnoozeDuration", QVariant(m_snoozeDuration));
}

void Settings::setVibration(QString vibration)
{
    if(m_vibration == vibration) {
        // Don't send the vibration mode over dbus if it is the same one already
        return;
    }

    // Change the property and let qml know about it
    m_vibration = vibration;
    emit vibrationChanged();

    setDBusProperty("HapticFeedback", QVariant(m_vibration));
}
