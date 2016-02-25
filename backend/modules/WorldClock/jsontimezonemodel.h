/*
 * Copyright (C) 2014-2016 Canonical Ltd
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

#ifndef JSONTIMEZONEMODEL_H
#define JSONTIMEZONEMODEL_H

#include <QUrl>
#include <QNetworkAccessManager>

#include "timezonemodel.h"

class JsonTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    // Property to store the json document source
    Q_PROPERTY(QUrl source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)

public:
    JsonTimeZoneModel(QObject *parent = 0);

    // Function to read the json document source
    QUrl source() const;

    // Function to set the source
    void setSource(const QUrl &source);

signals:
    // Signal to notify the change of the source to QML
    void sourceChanged();

private slots:
    // Function to process the json document when a reply is received
    void networkReplyFinished(QNetworkReply *reply);

private:
    // Private copy of the source received from QML
    QUrl m_source;

    // Network access manager to request data from the online source
    QNetworkAccessManager *m_nam;

    // Function to initiate the retrieval process
    void loadTimeZonesFromJson();
};

#endif // JSONTIMEZONEMODEL_H
