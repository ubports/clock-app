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

#ifndef LOCATION_H
#define LOCATION_H

#include <QObject>
#include <QUrl>
#include <QNetworkAccessManager>

class GeoLocation : public QObject
{
    Q_OBJECT

    // Property to set the user's longitude and latitude
    Q_PROPERTY(QUrl source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)

    // Property to return the user's location (cityname or countryname)
    Q_PROPERTY(QString location
               READ location
               NOTIFY locationChanged)

public:
    GeoLocation(QObject *parent = 0);

    // Function to read the json document source
    QUrl source() const;

    // Function to set the source
    void setSource(const QUrl &source);

    // Function to read the user's location
    QString location() const;

signals:
    // Signal to notify the source has been changed
    void sourceChanged();

    // Signal to notify the location has been changed
    void locationChanged();

private slots:
    // Function to process the json document when a reply is received
    void networkReplyFinished(QNetworkReply *reply);

private:
    // Private copy of the source received from QML
    QUrl m_source;

    // Network access manager to request data from the online source
    QNetworkAccessManager *m_nam;

    // Private copy of the user location
    QString m_location;

    // Function to initiate the location retrieval process
    void retrieveLocationFromJson();
};

#endif // LOCATION_H
