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

#include <QUrl>

#include "timezonemodel.h"

class XmlTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    // Source property to set the source of the XML List Model
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)

public:
    XmlTimeZoneModel(QObject *parent = 0);

    // Function to read the source of the XML list model
    QUrl source() const;

    // Function to set the source of the XML list model
    void setSource(const QUrl &source);

signals:
    // Signal to trigger when the source is changed
    void sourceChanged();

private:
    // Keep a store of the source property
    QUrl m_source;

    // Function to do the XML parsing
    void loadTimeZonesFromXml();
};

#endif // XMLTIMEZONEMODEL_H
