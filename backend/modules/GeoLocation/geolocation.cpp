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

#include "geolocation.h"

GeoLocation::GeoLocation(QObject *parent):
    QObject(parent)
{
    m_nam = new QNetworkAccessManager(this);
    connect(m_nam,
            SIGNAL(finished(QNetworkReply*)),
            this,
            SLOT(networkReplyFinished(QNetworkReply*)));
}

QUrl GeoLocation::source() const
{
    return m_source;
}

QString GeoLocation::location() const
{
    return m_location;
}

void GeoLocation::setSource(const QUrl &source)
{
    if (m_source == source) {
        // Don't set the source again if it is the same source being set again
        return;
    }

    // Update the source and emit the changed signal to let QML know
    m_source = source;
    emit sourceChanged();

    retrieveLocationFromJson();
}

void GeoLocation::retrieveLocationFromJson()
{
    // Define the request
    QNetworkRequest request(m_source);

    // Make the request to retrieve the data
    m_nam->get(request);
}

void GeoLocation::networkReplyFinished(QNetworkReply *reply)
{
    if(reply->error() != QNetworkReply::NoError) {
        qDebug() << "[LOG] Network error: " << reply->errorString();
        return;
    }

    QByteArray data = reply->readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);

    QVariant cityData = jsonDoc.toVariant();

    foreach (const QVariant &entry, cityData.toMap().value("geonames").toList())
    {
        auto data = entry.toMap();
        auto adminName2 = data.value("adminName2").toString();
        auto adminName1 = data.value("adminName1").toString();

        if (!adminName2.isEmpty()) {
            m_location = adminName2;
            emit locationChanged();
        }

        else if (!adminName1.isEmpty()) {
            m_location = adminName1;
            emit locationChanged();
        }
    }

    reply->deleteLater();
}
