#ifndef ZONE_H
#define ZONE_H

#include <QObject>
#include <QDateTime>
#include <QTimeZone>
#include <QList>
#include <QByteArray>
#include <QDebug>

class Zone : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(Zone)

public:
    Zone(QObject *parent = 0);
    ~Zone();

public slots:
    QDateTime getLocalTime();

private:
    QDateTime m_time;
    QTimeZone m_timezone;
};

#endif // ZONE_H
