#ifndef TIMEZONE_H
#define TIMEZONE_H

#include <QObject>

class Timezone : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString helloWorld READ helloWorld WRITE setHelloWorld NOTIFY helloWorldChanged )

public:
    explicit Timezone(QObject *parent = 0);
    ~Timezone();

Q_SIGNALS:
    void helloWorldChanged();

protected:
    QString helloWorld() { return m_message; }
    void setHelloWorld(QString msg) { m_message = msg; Q_EMIT helloWorldChanged(); }

    QString m_message;
};

#endif // TIMEZONE_H
