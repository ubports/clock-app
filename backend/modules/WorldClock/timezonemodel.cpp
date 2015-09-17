/*
 * Copyright (C) 2014-2015 Canonical Ltd
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

#include <QDateTime>
#include <QTimeZone>
#include <QDebug>

#include "timezonemodel.h"

TimeZoneModel::TimeZoneModel(QObject *parent):
    QAbstractListModel(parent)
{
    // By Default set status to ready. Any further operations will change it.
    m_status = TimeZoneModel::Ready;

    m_updateTimer.setInterval(0);
    connect(&m_updateTimer, &QTimer::timeout, this, &TimeZoneModel::update);
}

/*
 In order for Qt/QML to know how many entries our model has, we need to
 implement rowCount() and return the amount of rows.
*/
int TimeZoneModel::rowCount(const QModelIndex &parent) const
{
    /*
     QT's models also handle tables and tree views, so the index is not just a
     integer but consists of a parent, row and a column. Since we using a simple
     list model, let's ignore the parent. Q_UNUSED(parent) gets rid of the
     compiler warning about the unused variable.
    */
    Q_UNUSED(parent)

    return m_citiesData.count();
}

/*
 Main function to get the data out of the model. We need to return our stuff
 here.
*/
QVariant TimeZoneModel::data(const QModelIndex &index, int role) const
{
    /*
     Again, ignore everything from the index except row. Were' not into tables
     and trees.
    */
    int row = index.row();

    /*
     Now, each cell can have multiple values, e.g. a text value, a color value,
     an icon value and what not. Those things are selected by using "roles".
     We have defined Roles in our .h file. Lets use them here.
    */

    switch (role) {
    case RoleCityId:
        return m_citiesData.at(row).cityId;
    case RoleCityName:
        return m_citiesData.at(row).cityName;
    case RoleCountryName:
        return m_citiesData.at(row).countryName;
    case RoleTimezoneId:
        return m_citiesData.at(row).timeZone.id();
    }

    QDateTime currentDateTime = QDateTime::currentDateTime();
    QDateTime worldCityTime(currentDateTime.toTimeZone(m_citiesData.at(row).timeZone));

    switch (role) {
    case RoleNotLocalizedTimeString:
        /*
         FIXME: Until https://bugreports.qt-project.org/browse/QTBUG-40275
         is fixed, we will have to return a string.
        */
        return worldCityTime.toString("hh:mm:ss");
    case RoleLocalizedTimeString:
        return worldCityTime.time().toString(Qt::DefaultLocaleShortDate);
    case RoleTimeTo:
        /*
         FIXME: Workaround for currentDateTime.secsTo(worldCityTime) which returns
         0 indicating that the datetime object is invalid.
        */
        return currentDateTime.offsetFromUtc() - worldCityTime.offsetFromUtc();
    }

    /*
     In case the method was called with an invalid index or role, let's
     return an empty QVariant
    */
    return QVariant();
}

QHash<int, QByteArray> TimeZoneModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleCityId, "cityId");
    roles.insert(RoleCityName, "cityName");
    roles.insert(RoleCountryName, "countryName");
    roles.insert(RoleTimezoneId, "timezoneID");
    roles.insert(RoleNotLocalizedTimeString, "notLocalizedZoneTime");
    roles.insert(RoleLocalizedTimeString, "localizedZoneTime");
    roles.insert(RoleTimeTo, "timeTo");
    return roles;
}

int TimeZoneModel::updateInterval() const
{
    return m_updateTimer.interval();
}

void TimeZoneModel::setUpdateInterval(int updateInterval)
{
    if (m_updateTimer.interval() != updateInterval)
    {
        m_updateTimer.setInterval(updateInterval);
        emit updateIntervalChanged();

        if (m_updateTimer.interval() > 0)
        {
            m_updateTimer.start();
        }
        else {
            m_updateTimer.stop();
        }
    }
}

void TimeZoneModel::update()
{
    /*
     All we have to do is to emit notifications for the view's to re-request
     the data for role timezoneID and role TimeTo. The time will be calculated
     on the fly. For that we emit dataChanged with a startIndex of 0, an
     endIndex for the last item and the RoleTimeString and RoleTimeTo as the
     changed roles.
    */

    QModelIndex startIndex = index(0);
    QModelIndex endIndex = index(m_citiesData.count() - 1);
    QVector<int> roles;
    roles << RoleLocalizedTimeString << RoleNotLocalizedTimeString << RoleTimeTo;
    emit dataChanged(startIndex, endIndex, roles);
}

void TimeZoneModel::setStatus(TimeZoneModel::Status status)
{
    if(m_status == status)
    {
        return;
    }

    m_status = status;
    emit statusChanged();
}

TimeZoneModel::Status TimeZoneModel::status() const
{
    return m_status;
}
