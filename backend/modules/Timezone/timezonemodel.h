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

#ifndef TIMEZONEMODEL_H
#define TIMEZONEMODEL_H

#include <QAbstractListModel>
#include <QTimer>
#include <QTimeZone>

/*
  TimeZoneModel class based on QAbstractListModel to make it compatible with
  QML's ListView.
*/
class TimeZoneModel: public QAbstractListModel
{
    Q_OBJECT

    /*
      Property to determine the interval before updating the time (default is 0)
    */
    Q_PROPERTY(int updateInterval
               READ updateInterval
               WRITE setUpdateInterval
               NOTIFY updateIntervalChanged)

    // ENUM list for different status (Loading, Error, Ready)
    Q_ENUMS(Status)

    // Property to determine the status of the timezone object
    Q_PROPERTY(Status status
               READ status
               NOTIFY statusChanged)

public:
    enum Roles {
        RoleCityName,
        RoleCountryName,
        RoleTimeZoneId,
        RoleTimeString,
        RoleDaysTo,
        RoleTimeTo,
    };

    enum Status {
        Loading,
        Error,
        Ready,
    };

    /*
     A simple constructor initialize variable values. Added the standard QObject
    *parent parameter to help Qt with "garbage collection.
    */
    TimeZoneModel(QObject *parent = 0);

    /*
     Let's override the pure virtual functions (the ones marked as
     "virtual" and have "= 0" in the end.
    */
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    /*
     As QML can't really deal with the Roles enum above, we need a mapping
     between the enum and strings
    */
    QHash<int, QByteArray> roleNames() const override;

    // Function to read the update interval
    int updateInterval() const;

    // Function to set the update interval
    void setUpdateInterval(int updateInterval);

signals:
    // Signal to notify the updateInterval change to QML
    void updateIntervalChanged();

    // Signal to notify the timezonemodel status change to QML
    void statusChanged();

public slots:
    /*
     Public slot called internally by m_updateTimer and also from QML to
     explicitly refresh the model when required.

     Use Case: The world city list is updated every minute to improve
     performance. However when the clock app is brought from the background
     (due to user switching between apps) the world city list must be updated
     immediately rather than waiting for a minute before updating.
    */
    void update();

private:
    // Timer to update the model at a set interval
    QTimer m_updateTimer;

protected:
    // Create a simple container class to hold our information
    struct TimeZone{
        QString cityName;
        QString country;
        QTimeZone timeZone;
    };

    // Keep a list of TimeZone objects, holding all our timeZones.
    QList<TimeZone> m_timeZones;
    Status m_status;

    // Function to set the status of the timezonemodel
    void setStatus(Status status);

    // Getter function for the status property
    Status status() const;
};

#endif
