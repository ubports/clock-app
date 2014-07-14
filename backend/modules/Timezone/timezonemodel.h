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

#ifndef TIMEZONEMODEL_H
#define TIMEZONEMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QUrl>
#include <QTimer>

// Create a simple container class to hold our information
class TimeZone
{
public:
    QString cityName;
    QString country;
    QString timeZoneId;
};


// We're going to use QAbstractListModel as the base class
// That makes it compatible to QML's ListView.
class TimeZoneModel: public QAbstractListModel
{
    Q_OBJECT

    // A this property determines the interval for updating time. The default, 0, doesn't update at all
    Q_PROPERTY(int updateInterval READ updateInterval WRITE setUpdateInterval NOTIFY updateIntervalChanged)

public:
    enum Roles {
        RoleCityName,
        RoleCountyName,
        RoleTimeZoneId,
        RoleTimeString
    };

    // A simple constructor. Add the standard QObject *parent parameter.
    // That helps Qt with "garbage collection"
    TimeZoneModel(QObject *parent = 0);

    // Let's override the pure virtual functions (the ones marked as
    // "virtual" and have "= 0" in the end.
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    // As QML can't really deal with the Roles enum above, we need a mapping
    // between the enum and strings
    QHash<int, QByteArray> roleNames() const override;

    int updateInterval() const;
    void setUpdateInterval(int updateInterval);

signals:
    // and we need a signal for the NOTIFY when the properties change
    void updateIntervalChanged();

private slots:
    // A private slot that gets called by the updateTimer
    void update();

private:
    // Have a timer to update stuff
    QTimer m_updateTimer;

protected:
    // Keep a list of TimeZone objects, holding all our timeZones.
    QList<TimeZone> m_timeZones;
};

#endif
