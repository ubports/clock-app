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

    /*
     FIXME: Due to upstream QT Bug at
     https://bugreports.qt-project.org/browse/QTBUG-40275, we are forced to
     return a string instead of a QDateTime object. As a result, we are
     returning the string in the format specified below and then use that to
     construct a new Date() object in the qml side which is then displayed
     in the correct user locale.
    */

    // Property to determine not localized string of local time (format yyyy:MM:dd:hh:mm:ss)
    Q_PROPERTY(QString notLocalizedCurrentDateTimeString
               READ notLocalizedCurrentDateTimeString
               NOTIFY notLocalizedCurrentDateTimeStringChanged)

    // Property to determine the localized string of local time (format Qt::DefaultLocaleShortDate)
    Q_PROPERTY(QString localizedCurrentTimeString
               READ localizedCurrentTimeString
               NOTIFY localizedCurrentTimeStringChanged)

    // Property to determine the localized string of local date (format Qt::DefaultLocaleLongDate)
    Q_PROPERTY(QString localizedCurrentDateString
               READ localizedCurrentDateString
               NOTIFY localizedCurrentDateStringChanged)
public:
    DateTime(QObject *parent = 0);

    // Function to read the update interval
    int updateInterval() const;

    // Function to set the update interval
    void setUpdateInterval(int updateInterval);

    QString notLocalizedCurrentDateTimeString() const;

    // Function to read the local time string
    QString localizedCurrentTimeString() const;

    // Function to read the local date string
    QString localizedCurrentDateString() const;

signals:

    void notLocalizedCurrentDateTimeStringChanged();

    // Signal to notify the local time string change to QML
    void localizedCurrentTimeStringChanged();

    // Signal to notify the local date string change in QML
    void localizedCurrentDateStringChanged();

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
    QString m_notLocalizedCurrentDateTime;
    QString m_localizedCurrentTime;
    QString m_localizedCurrentDate;

    // Private internal timer to update the values at a specified interval
    QTimer m_updateTimer;
};

#endif // DATETIME_H
