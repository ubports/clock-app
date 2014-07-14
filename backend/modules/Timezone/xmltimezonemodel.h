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

#ifndef XMLTIMEZONEMODEL_H
#define XMLTIMEZONEMODEL_H

#include <QFile>
#include <QDebug>
#include <QXmlStreamReader>
#include <QTimeZone>
#include <QDateTime>
#include <QUrl>

#include "timezonemodel.h"

class XmlTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    // Let's have a source property for the xml file, just like the XmlListModel
    // NOTE: Not too sure why I moved the source property to this subclass since
    // I might require it in the U1db TimezoneModel subclass as well.
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)

public:
    XmlTimeZoneModel(QObject *parent = 0);

    // We need to implement the READ and WRITE methods of the properties
    QUrl source() const;
    void setSource(const QUrl &source);

signals:
    void sourceChanged();

private:
    // And keel a store of the source property
    QUrl m_source;

    // Lets do the xml parsing in a separate function for less messy code
    void loadTimeZonesFromXml();
};

#endif // XMLTIMEZONEMODEL_H
