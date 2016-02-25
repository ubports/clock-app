/*****************************************************************************
 * Copyright: 2015-2016 Michael Zanetti <michael_zanetti@gmx.net>            *
 *            2015-2016 Bartosz Kosiorek <gang65@poczta.onet.pl>             *
 *                                                                           *
 * This prject is free software: you can redistribute it and/or modify       *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, version 3 of the License.                   *
 *                                                                           *
 * This project is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of            *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
 * GNU General Public License for more details.                              *
 *                                                                           *
 * You should have received a copy of the GNU General Public License         *
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.     *
 *                                                                           *
 ****************************************************************************/

#ifndef ENGINE_H
#define ENGINE_H

#include <QAbstractListModel>
#include <QTimer>
#include <QSettings>
#include <QDateTime>

class StopwatchEngine : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY( bool running
                READ running
                NOTIFY runningChanged)

    Q_PROPERTY( int totalTimeOfStopwatch
                READ totalTimeOfStopwatch
                NOTIFY totalTimeOfStopwatchChanged)

    Q_PROPERTY( int previousTimeOfStopwatch
                READ previousTimeOfStopwatch
                NOTIFY previousTimeOfStopwatchChanged)

signals:
    // Signal to notify the running status change to QML
    void runningChanged();

    // Signal to notify the total time change to QML
    void totalTimeOfStopwatchChanged();

    // Signal to notify the total time change to QML
    void previousTimeOfStopwatchChanged();

public:
    enum Role {
        RoleTotalTime,
        RoleDiffToPrevious
    };

    explicit StopwatchEngine(QObject *parent = 0);

    /*
     Let's override the pure virtual functions (the ones marked as
     "virtual" and have "= 0" in the end.
    */
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;

    /*
     As QML can't really deal with the Roles enum above, we need a mapping
     between the enum and strings
    */
    QHash<int, QByteArray> roleNames() const override;

    // Getter functions for the properties
    bool running() const;
    int totalTimeOfStopwatch() const;
    int previousTimeOfStopwatch() const;

    Q_INVOKABLE void addLap();
    Q_INVOKABLE void removeLap(int lapIndex);

    Q_INVOKABLE void startStopwatch();
    Q_INVOKABLE void pauseStopwatch();
    Q_INVOKABLE void clearStopwatch();

private slots:
    void updateStopwatch();    

private:
    void setStopwatchStartDateTime();

    void setRunning(bool value);
    void setTotalTimeOfStopwatch(int value);
    void setPreviousTimeOfStopwatch(int value);

    QSettings m_settings;

    QDateTime m_stopwatchStartDateTime;
    QTimer m_timer;

    bool m_isStopwatchRunning;
    int m_previousTimeInmsecs;
    int m_totalTimeInmsecs;
};

#endif // ENGINE_H
