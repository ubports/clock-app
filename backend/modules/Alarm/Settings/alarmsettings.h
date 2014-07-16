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

class AlarmSettings: public QObject
{
    Q_OBJECT

    // Property to control the volume of the alarm
    Q_PROPERTY(unsigned int volume READ volume WRITE setVolume NOTIFY volumeChanged)

    // Property to control how long the alarm will ring before stopping
    Q_PROPERTY(unsigned int duration READ duration WRITE setDuration NOTIFY durationChanged)

public:
    AlarmSettings(QObject *parent = 0);

    // Function to return the alarm volume
    unsigned int volume() const;

    // Function to return the alarm duration
    unsigned int duration() const;

    // Function to set the alarm volume
    void setVolume(const unsigned int &volume);

    // Function to set the alarm duration
    void setDuration(const unsigned int &duration);

    // ***************  Cannot Get this to work :/ **********
    Q_INVOKABLE void testOutput(const QString &outputString);

signals:
    // Signal to notify the volume change to QML
    void volumeChanged();

    // QML to notify the duration change to QML
    void durationChanged();

private:
    unsigned int m_volume, m_duration;
};

#endif
