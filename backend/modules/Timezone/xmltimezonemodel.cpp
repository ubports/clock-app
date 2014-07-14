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

#include "xmltimezonemodel.h"

XmlTimeZoneModel::XmlTimeZoneModel(QObject *parent):
    TimeZoneModel(parent)
{
}

QUrl XmlTimeZoneModel::source() const
{
    return m_source;
}

void XmlTimeZoneModel::setSource(const QUrl &source)
{
    if (m_source == source) {
        // Don't parse the file again if the source is the same already
        return;
    }

    // Change the property and let people know by emitting the changed signal
    m_source = source;
    emit sourceChanged();

    // Ultimately load the file
    loadTimeZonesFromXml();
}

void XmlTimeZoneModel::loadTimeZonesFromXml()
{
    // Let qml know that the model will be cleared and rebuilt
    beginResetModel();

    m_timeZones.clear();

    QFile file(m_source.path());
    if (!file.open(QFile::ReadOnly)) {
        qWarning() << "Can't open" << m_source << ". Model will be empty.";
        endResetModel();
        return;
    }
    QXmlStreamReader reader(&file);
    bool haveCities = false;
    bool isCityName = false;
    bool isCountryName = false;
    bool isTzId = false;

    TimeZone tz;
    while (!reader.atEnd() && !reader.hasError()) {
        QXmlStreamReader::TokenType token = reader.readNext();

        // Skip any header
        if(token == QXmlStreamReader::StartDocument) {
            continue;
        }

        if (token == QXmlStreamReader::StartElement) {

            // skip anything outside the Cities tag
            if (!haveCities) {
                if (reader.name() == "Cities") {
                    haveCities = true;
                }
                continue;
            }

            if (reader.name() == "City") {
                // A new time zone begins. clear tz
                tz = TimeZone();
            }
            if (reader.name() == "cityName") {
                isCityName = true;
            }
            if (reader.name() == "countryName") {
                isCountryName = true;
            }
            if (reader.name() == "timezoneID") {
                isTzId = true;
            }
        }

        if (token == QXmlStreamReader::Characters) {

            if (isCityName) {
                tz.cityName = reader.text().toString();
            }
            if (isCountryName) {
                tz.country = reader.text().toString();
            }
            if (isTzId) {
                tz.timeZoneId = reader.text().toString();
            }
        }

        if (token == QXmlStreamReader::EndElement) {
            if (reader.name() == "Cities") {
                haveCities = false;
            }
            if (reader.name() == "City") {
                // A time zone has ended. insert it into list
                m_timeZones.append(tz);
                qDebug() << "appended tz:" << tz.cityName << tz.country << tz.timeZoneId;
            }
            if (reader.name() == "cityName") {
                isCityName = false;
            }
            if (reader.name() == "countryName") {
                isCountryName = false;
            }
            if (reader.name() == "timezoneID") {
                isTzId = false;
            }
        }
    }

    // Let QML know that the model is usable again.
    endResetModel();
}
