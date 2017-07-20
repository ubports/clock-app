#ifndef ENGINE_H
#define ENGINE_H

#include <QAbstractListModel>
#include <QTimer>
#include <QSettings>
#include <QDateTime>

class TimerEngine : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY( bool running
                READ running
                NOTIFY runningChanged)

signals:
    // Signal to notify the running status change to QML
    void runningChanged();


public:

    /*
     Let's override the pure virtual functions (the ones marked as
     "virtual" and have "= 0" in the end.
    */
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;

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

    QSettings m_settings;

    QTimer m_timer;

    bool m_isTimerRunning;
};

#endif // ENGINE_H
