#include "zone.h"

Zone::Zone(QObject *parent) :
    QObject(parent),
    m_time(QDateTime::currentDateTime())
{

}

Zone::~Zone() {

}

QDateTime Zone::getLocalTime() {
    QList<QByteArray> ids = QTimeZone::availableTimeZoneIds();

    QByteArray test("America/Chicago");

    QTimeZone zone = QTimeZone("America/Chicago");

    QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
    qDebug() << zoneTime.time();

    m_time.setTimeSpec(Qt::TimeZone);
    m_time.toTimeZone(zone);

    qDebug() << m_time;

    return m_time;
}
