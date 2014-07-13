#include "zone.h"

Zone::Zone(QObject *parent) :
    QObject(parent),
    m_time(QDateTime::currentDateTime())
{

}

Zone::~Zone() {

}

QDateTime Zone::getLocalTime(QByteArray *timezoneID) {
    // Create a QTimeZone object and initiate it with the timezone ID provided
    QTimeZone zone = QTimeZone(*timezoneID);

    // Convert the QDateTime object to the timezone provided
    m_time.toTimeZone(zone);

    qDebug() << m_time;

    return m_time;
}
