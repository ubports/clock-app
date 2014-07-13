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
//    QDateTime getLocalTime(QByteArray *timezoneID);


// You shouldn't use slots with return values... Instead, make a public
// function and mark it as Q_INVOKABLE
public:
    // You shouldn't use a pointer (*) to QByteArray. There's only very few cases
    // where that is desirable. Until you understand the difference, better
    // stick to references (&) like this:
    Q_INVOKABLE QDateTime getLocalTime(const QByteArray &timeZoneId) const;

    // Marking the parameter and the method "const" is good practice and helps
    // with keeping the code easier to maintain, but it's not required. Don't
    // get hung up on those if you're not understanding those yet.

    // You could also just use this:
    // QDateTime getLocalTime(QByteArray timeZoneId);
    // That, however, makes the code slower, because it creates a copy of
    // timeZoneId before passing it into the function. Using & doesn't
    // do that and refers to the original value. We're using const to make
    // sure to not accidentally change the original value.


    // Workaround for QDateTime losing timezone information
    Q_INVOKABLE QString getCurrentTimeString(const QByteArray &timeZoneId) const;


private:
    QDateTime m_time; // delete this
};

#endif // ZONE_H
