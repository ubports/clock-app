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
    /*
     * Public function to receive a Olson Timezone ID as argument and
     * output that timezone's QDateTime object.
    */
    QDateTime getLocalTime(QByteArray *timezoneID);

private:
    QDateTime m_time;
};

#endif // ZONE_H
