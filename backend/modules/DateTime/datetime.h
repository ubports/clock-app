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

#ifndef DATETIME_H
#define DATETIME_H

#include <QObject>
#include <QTimer>

class DateTime : public QObject
{
    Q_OBJECT

    // Property to determine the interval before updating the time (default 1 sec)
    Q_PROPERTY(int updateInterval
               READ updateInterval
               WRITE setUpdateInterval
               NOTIFY updateIntervalChanged)

    // Property to determine the local time string (format hh:mm:ss)
    Q_PROPERTY(QString localTimeString
               READ localTimeString
               NOTIFY localTimeStringChanged)

    // Property to determine the local date string (format yyyy:M:d)
    Q_PROPERTY(QString localDateString
               READ localDateString
               NOTIFY localDateStringChanged)
public:
    DateTime(QObject *parent = 0);

    // Function to read the update interval
    int updateInterval() const;

    // Function to set the update interval
    void setUpdateInterval(int updateInterval);

    // Function to read the local time string
    QString localTimeString() const;

    // Function to read the local date string
    QString localDateString() const;

signals:
    // Signal to notify the local time string change to QML
    void localTimeStringChanged();

    // Signal to notify the local date string change in QML
    void localDateStringChanged();

    // Signal to notify the updateInterval change to QML
    void updateIntervalChanged();

public slots:
    /*
     Function called by m_timer to update the date & time every second
     and also when the clock app is brough from the background
    */
    void update();

private:
    // Private copies of the local time and date
    QString m_localtime;
    QString m_localdate;

    // Private internal timer to update the values at a specified interval
    QTimer m_updateTimer;
};

#endif // DATETIME_H
