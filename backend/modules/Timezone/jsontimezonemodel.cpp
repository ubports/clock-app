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
    TimeZoneModel(parent)
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

void JsonTimeZoneModel::setSource(const QUrl &source)
{
    if (m_source == source) {
        // Don't set the source again if it is the same source being set again
        return;
    }

    // Update the source and emit the changed signal to let QML know
    m_source = source;
    emit sourceChanged();

    setStatus(TimeZoneModel::Loading);

    // Start the retrieval process
    loadTimeZonesFromJson();
}

void JsonTimeZoneModel::loadTimeZonesFromJson()
{
    // Define the request
    QNetworkRequest request(m_source);

    // Make the request to retrieve the data
    m_nam->get(request);
}

void JsonTimeZoneModel::networkReplyFinished(QNetworkReply *reply)
{
    if(reply->error() != QNetworkReply::NoError) {
        qDebug() << "[LOG] Network error: " << reply->errorString();

        setStatus(TimeZoneModel::Error);
        emit statusChanged();

        return;
    }

    QByteArray data = reply->readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);

    QVariant timezoneData = jsonDoc.toVariant();

    // Let QML know model is being reset and rebuilt
    beginResetModel();

    m_timeZones.clear();

    /*
     Cycle through each QVariant object and transfer them to the TimeZone
     list.
    */
    foreach (const QVariant &entry, timezoneData.toList()) {
        TimeZone tz;

        auto data = entry.toMap();
        auto admin1 = data.value("admin1").toString();
        auto admin2 = data.value("admin2").toString();
        auto country = data.value("country").toString();

        tz.cityName = data.value("name").toString();

        if (!admin1.isEmpty() && !admin2.isEmpty()) {
            tz.country = QString("%1, %2, %3").arg(admin2).arg(admin1).arg(country);
        } else if (!admin1.isEmpty()) {
            tz.country = QString("%1, %2").arg(admin1).arg(country);
        } else if (!admin2.isEmpty()) {
            tz.country = QString("%1, %2").arg(admin2).arg(country);
        } else {
            tz.country = country;
        }

        tz.timeZone = QTimeZone(data.value("timezone").toString().toLatin1());

        m_timeZones.append(tz);
    }

    setStatus(TimeZoneModel::Ready);

    // Let QML know model is reusable again
    endResetModel();

    reply->deleteLater();
}
