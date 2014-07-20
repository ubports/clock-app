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

#include "u1dbtimezonemodel.h"

#include <QDebug>

U1dbTimeZoneModel::U1dbTimeZoneModel(QObject *parent) :
    TimeZoneModel(parent)
{
}

QList<QVariant> U1dbTimeZoneModel::model() const
{
    return m_model;
}

void U1dbTimeZoneModel::setModel(QList<QVariant> &model)
{
    if(m_model == model) {
        // Don't parse the model again if it is the same model being set again
        return;
    }

    // Change the model and emit the changed signal to let QML know
    m_model = model;
    emit modelChanged();

    // Parse through model
    loadTimeZonesFromU1db();
}

void U1dbTimeZoneModel::loadTimeZonesFromU1db()
{
    if(m_model.isEmpty()) {
        // Don't parse an empty model
        return;
    }

    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    TimeZone tz;

    /*
     Cycle through the u1db query model results and transfer them to the
     TimeZone list.
    */
    for (int i=0; i < m_model.size(); i++) {
        // Map query model results to timezone tz
        tz.cityName = m_model.value(i).toMap().value("city").toString();
        tz.country = m_model.value(i).toMap().value("country").toString();
        tz.timeZoneId = m_model.value(i).toMap().value("timezone").toString();

        m_timeZones.append(tz);

        // Clear tz before next iteration
        tz = TimeZone();
    }


    // Let QML know model is reusable again
   endResetModel();
}
