#ifndef ZONE_H
#define ZONE_H

#include <QObject>

class Zone : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString helloWorld READ helloWorld WRITE setHelloWorld NOTIFY helloWorldChanged )

public:
    explicit Zone(QObject *parent = 0);
    ~Zone();

Q_SIGNALS:
    void helloWorldChanged();

protected:
    QString helloWorld() { return m_message; }
    void setHelloWorld(QString msg) { m_message = msg; Q_EMIT helloWorldChanged(); }

    QString m_message;
};

#endif // ZONE_H
