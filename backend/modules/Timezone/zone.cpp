#include "zone.h"

// This is the constructor
// It will only be called once, when a new "Zone" object is created.
// If you read currentDateTime in here, it'll stick to the time when the
// Object is created and not reflect the current time when getLocalTime is called.
Zone::Zone(QObject *parent) :
    QObject(parent),
    m_time(QDateTime::currentDateTime()) // delete this
{

}

Zone::~Zone() {

}

//QDateTime Zone::getLocalTime(QByteArray *timezoneID) {
//    // Create a QTimeZone object and initiate it with the timezone ID provided
//    QTimeZone zone = QTimeZone(*timezoneID);

//    // Convert the QDateTime object to the timezone provided
//    m_time.toTimeZone(zone);

//    qDebug() << m_time;

//    return m_time;
//}

// In my opinion this should work but it doesn't will ask some other people
// and report a bug if m suspicion turns out to be true.
QDateTime Zone::getLocalTime(const QByteArray &timeZoneId) const
{
    QTimeZone zone(timeZoneId);
    return QDateTime::currentDateTime().toTimeZone(zone);
}

// So. let's use this instead:
QString Zone::getCurrentTimeString(const QByteArray &timeZoneId) const
{
    return getLocalTime(timeZoneId).toString();
}
