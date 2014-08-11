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

#include <QDebug>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>

#include "jsontimezonemodel.h"

JsonTimeZoneModel::JsonTimeZoneModel(QObject *parent):
    TimeZoneModel(parent),
    m_loading(false)
{
    m_nam = new QNetworkAccessManager(this);
    connect(m_nam,
            SIGNAL(finished(QNetworkReply*)),
            this,
            SLOT(networkReplyFinished(QNetworkReply*)));
}

QUrl JsonTimeZoneModel::source() const
{
    return m_source;
}

bool JsonTimeZoneModel::loading() const
{
    return m_loading;
}

void JsonTimeZoneModel::setSource(const QUrl &source)
{
    if (m_source == source) {
        // Don't set the source again if it is the same source being set again
        return;
    }

    // Update the source and emit the changed signal to let QML know
    m_source = source;
    emit sourceChanged();

    // Start the retrieval process
    loadTimeZonesFromJson();
}

void JsonTimeZoneModel::loadTimeZonesFromJson()
{
    // Define the request
    QNetworkRequest request(m_source);

    m_loading = true;
    emit loadingChanged();

    // Make the request to retrieve the data
    m_nam->get(request);
}

void JsonTimeZoneModel::networkReplyFinished(QNetworkReply *reply)
{
    QByteArray data = reply->readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);

    QVariant timezoneData = jsonDoc.toVariant();

//    if(timezoneData.isNull()) {
//        return;
//    }

    m_loading = false;
    emit loadingChanged();

    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    TimeZone tz;

    /*
     Cycle through each QVariant object and transfer them to the TimeZone
     list.
    */
    foreach (const QVariant &entry, timezoneData.toList()) {
        QString temp_timezone("Europe/Amsterdam");

        tz.cityName = entry.toMap().value("name").toString();
        tz.country = entry.toMap().value("country").toString();
        tz.timeZone = QTimeZone(temp_timezone.toLatin1());

        m_timeZones.append(tz);

        // Clear tz before next iteration
        tz = TimeZone();
    }

    // Let QML know model is reusable again
    endResetModel();

    reply->deleteLater();
}
