
#include "timezonemodel.h"

#include <QTimeZone>
#include <QFile>
#include <QXmlStreamReader>
#include <QTimeZone>
#include <QDebug>

TimeZoneModel::TimeZoneModel(QObject *parent):
    QAbstractListModel(parent)
{
    m_updateTimer.setInterval(0);
    connect(&m_updateTimer, &QTimer::timeout, this, &TimeZoneModel::update);
}

// In order for Qt/QML to know how many entries our model has, we
// need to implement rowCount() and return the amount of rows.
int TimeZoneModel::rowCount(const QModelIndex &parent) const
{
    // Qt's models can also handle tables and tree views, so the index
    // is not just a integer, but consists of a parent, a row and acolumn.
    // We're just using the siple list mode, so let's ignore the parent.
    // Using Q_UNUSED(parent) gets rid of the compile warning about the
    // unused variable.
    Q_UNUSED(parent)

    return m_timeZones.count();
}

// This is the main function to get the data out of the model.
// We need to return our stuff here.
QVariant TimeZoneModel::data(const QModelIndex &index, int role) const
{
    // Again, ignore everything from the index except row. Were' not into tables and trees.
    int row = index.row();

    // Now, each cell can have multiple values, e.g. a text value, a color value,
    // an icon value and what not. Those things are selected by using "roles".
    // We have defined Roles in our .h file. Lets use them here.

    switch (role) {
    case RoleCityName:
        return m_timeZones.at(row).cityName;
    case RoleCountyName:
        return m_timeZones.at(row).country;
    case RoleTimeZoneId:
        return m_timeZones.at(row).timeZoneId;
    case RoleTimeString:
        QTimeZone zone(m_timeZones.at(row).timeZoneId.toLatin1());
        // TODO: pass formatting options as parameter to toString().
        // see: http://qt-project.org/doc/qt-5/qdate.html#toString
        return QDateTime::currentDateTime().toTimeZone(zone).toString();
    }

    // In case the method was called with an invalid index or role, let's
    // return an empty QVariant
    return QVariant();
}

QHash<int, QByteArray> TimeZoneModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleCityName, "city");
    roles.insert(RoleCountyName, "country");
    roles.insert(RoleTimeZoneId, "timezoneID");
    roles.insert(RoleTimeString, "localTime");
    return roles;
}

QUrl TimeZoneModel::source() const
{
    return m_source;
}

void TimeZoneModel::setSource(const QUrl &source)
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

int TimeZoneModel::updateInterval() const
{
    return m_updateTimer.interval();
}

void TimeZoneModel::setUpdateInterval(int updateInterval)
{
    if (m_updateTimer.interval() != updateInterval) {
        m_updateTimer.setInterval(updateInterval);
        emit updateIntervalChanged();

        if (m_updateTimer.interval() > 0) {
            m_updateTimer.start();
        } else {
            m_updateTimer.stop();
        }
    }
}

void TimeZoneModel::loadTimeZonesFromXml()
{
    // Let qml know that the model will be cleared and rebuilt
    beginResetModel();

    m_timeZones.clear();

    QFile file(m_source.path());
    if (!file.open(QFile::ReadOnly)) {
        qWarning() << "Can't open" << m_source << ". Model will be empty.";
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

void TimeZoneModel::update()
{
    // All we have to do is to emit notifications for the view's to re-request
    // the data for role timezoneID because the time will be calculated on the
    // fly anyways
    // For that we emit dataChanged with a startIndex of 0, an endIndex for the
    // last item and the RoleTimeString as the changed roles.

    QModelIndex startIndex = index(0);
    QModelIndex endIndex = index(m_timeZones.count() - 1);
    QVector<int> roles;
    roles << RoleTimeString;
    emit dataChanged(startIndex, endIndex, roles);
}
