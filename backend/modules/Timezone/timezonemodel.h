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

public:
    enum Roles {
        RoleCityName,
        RoleCountryName,
        RoleTimeZoneId,
        RoleTimeString,
        RoleDaysTo,
        RoleTimeTo,
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

public slots:
    // Private slot that gets called by the updateTimer
    void update();

private:
    // Timer to update the model at a set interval
    QTimer m_updateTimer;

protected:
    // Create a simple container class to hold our information
    struct TimeZone{
        QString cityName;
        QString country;
        QString timeZoneId;
    };

    // Keep a list of TimeZone objects, holding all our timeZones.
    QList<TimeZone> m_timeZones;
};

#endif
