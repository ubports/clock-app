#ifndef TIMER_ENGINE_H
#define TIMER_ENGINE_H

#include <QAbstractListModel>

class TimerEngine : public QObject
{
    Q_OBJECT

    Q_PROPERTY( bool running
                READ running
                NOTIFY runningChanged)

signals:
    // Signal to notify the running status change to QML
    void runningChanged();


public:
    explicit TimerEngine(QObject *parent = 0);

    // Getter functions for the properties
    bool running() const;

    Q_INVOKABLE void addTimer(int timesec, QString timerName);
    Q_INVOKABLE void removeTimer(int timerIndex);

    Q_INVOKABLE void startTimer(int timesec);
    Q_INVOKABLE void pauseTimer();
    Q_INVOKABLE void clearTimer();

private slots:
    void updateTimer();

private:

    void setRunning(bool value);

    bool m_isTimerRunning = false;
};

#endif // TIMER_ENGINE_H
