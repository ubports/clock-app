/*
* Copyright (C) 2015 Canonical Ltd
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

#ifndef STATICTIMEZONEMODEL_H
#define STATICTIMEZONEMODEL_H

#include "timezonemodel.h"
#include <libintl.h>
#include <QDebug>

#define _(value) dgettext(GETTEXT_PACKAGE, value)

class StaticTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

public:
    StaticTimeZoneModel(QObject *parent = 0);

    // Function to get translated translated city and country name
    Q_INVOKABLE TimeZoneModel::TimeZoneData getTranslatedCityName(const QString &cityId);

private:
    // Function to define the default city list
    void loadDefaultCityList();

    // Function to append city list item into m_timeZones object
    void addCity(const QString &cityId, const QString &cityName, const QString &timezone, const QString &countryName);
};

#endif // STATICTIMEZONEMODEL_H
