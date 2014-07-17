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

#ifndef ALARMSETTINGS_H
#define ALARMSETTINGS_H

#include <QObject>
#include <QVariant>

class AlarmSettings: public QObject
{
    Q_OBJECT

    // Property to control the volume of the alarm
    Q_PROPERTY( int volume
                READ volume
                WRITE setVolume
                NOTIFY volumeChanged)

    // Property to control how long the alarm will ring before stopping
    Q_PROPERTY( int duration
                READ duration
                WRITE setDuration
                NOTIFY durationChanged)

public:
    AlarmSettings(QObject *parent = 0);

    // Function to return the alarm volume
    int volume() const;

    // Function to return the alarm duration
    int duration() const;

    // Function to set the alarm volume
    void setVolume(int volume);

    // Function to set the alarm duration
    void setDuration(int duration);

signals:
    // Signal to notify the volume change to QML
    void volumeChanged();

    // Signal to notify the duration change to QML
    void durationChanged();

private:
    // Keep a store of the alarm volume
    int m_volume;

    // Keep a store of the alarm duration
    int m_duration;

    // Function to retrieve all the settings from dBus and update the properties
    void refreshProperties();

    // Function to send new values for the dBus settings
    void setDBusProperty(const QString &name, const QVariant &value);

private slots:
    /*
     Function to update the clock alarm settings state automatically when
     settings values are changed on dBus side
    */
    void onSettingsChanged(const QString &interface,
                           const QVariantMap &properties,
                           const QStringList &valid);
};

#endif
