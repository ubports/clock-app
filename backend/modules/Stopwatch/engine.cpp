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

#include "engine.h"

#include <QStandardPaths>
#include <QDebug>

StopwatchEngine::StopwatchEngine(QObject *parent) :
    QAbstractListModel(parent),
    /*
     #FIXME: Change QStandardPaths::ConfigLocation to QStandardPaths::AppConfigLocation
     when Ubuntu Touch moves over to Qt 5.5. AppConfigLocation will directly return
     /home/phablet/.config/com.ubuntu.clock path.
    */
    m_settings(QStandardPaths::standardLocations(QStandardPaths::ConfigLocation).first() + "/com.ubuntu.clock/com.ubuntu.clock.conf", QSettings::IniFormat),
    m_previousTimeInmsecs(0),
    m_totalTimeInmsecs(0)
{
    qDebug() << "[LOG] Loading laps from " << m_settings.fileName();

    m_timer.setInterval(45);
    connect(&m_timer, &QTimer::timeout, this, &StopwatchEngine::updateStopwatch);

    QDateTime startTime = m_settings.value("Stopwatch/startDateTime").toDateTime();
    if(startTime.isValid())
    {
        m_stopwatchStartDateTime = startTime;
    }

    m_isStopwatchRunning = m_settings.value("Stopwatch/isStopwatchRunning").toBool();
    m_previousTimeInmsecs = m_settings.value("Stopwatch/previousTimeInmsecs").toInt();

    if(m_previousTimeInmsecs != 0) {
        setTotalTimeOfStopwatch(m_previousTimeInmsecs);
    }

    if(m_isStopwatchRunning == true)
    {
        m_timer.start();
    }
}

int StopwatchEngine::rowCount(const QModelIndex &parent) const
{
    /*
     QT's models also handle tables and tree views, so the index is not just a
     integer but consists of a parent, row and a column. Since we using a simple
     list model, let's ignore the parent. Q_UNUSED(parent) gets rid of the
     compiler warning about the unused variable.
    */
    Q_UNUSED(parent)

    return m_settings.value("Stopwatch/laps").toList().count();
}

QVariant StopwatchEngine::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case RoleTotalTime:
        return m_settings.value("Stopwatch/laps").toList().at(index.row());
    case RoleDiffToPrevious: {
        int previous = 0;
        if(index.row() != m_settings.value("Stopwatch/laps").toList().count() - 1)
        {
            previous = data(this->index(index.row() + 1), RoleTotalTime).toInt();
        }
        return m_settings.value("Stopwatch/laps").toList().at(index.row()).toInt() - previous;
    }
    }
    return QVariant();
}

QHash<int, QByteArray> StopwatchEngine::roleNames() const
{
    QHash< int, QByteArray> roles;
    roles.insert(RoleTotalTime, "totaltime");
    roles.insert(RoleDiffToPrevious, "laptime");
    return roles;
}

void StopwatchEngine::addLap()
{
    QVariantList laps = m_settings.value("Stopwatch/laps").toList();
    beginInsertRows(QModelIndex(), 0, 0);
    int timeDiff = m_totalTimeInmsecs;
    laps.prepend(timeDiff);
    m_settings.setValue("Stopwatch/laps", laps);
    endInsertRows();
}

void StopwatchEngine::removeLap(int lapIndex)
{
    QVariantList laps = m_settings.value("Stopwatch/laps").toList();
    beginRemoveRows(QModelIndex(), lapIndex, lapIndex);
    laps.removeAt(lapIndex);
    m_settings.setValue("Stopwatch/laps", laps);
    endRemoveRows();
}

void StopwatchEngine::setStopwatchStartDateTime()
{
    m_stopwatchStartDateTime = QDateTime::currentDateTimeUtc();
    m_settings.setValue("Stopwatch/startDateTime", m_stopwatchStartDateTime);
}

void StopwatchEngine::startStopwatch()
{
    setStopwatchStartDateTime();
    setRunning(true);
    m_timer.start();
}

void StopwatchEngine::updateStopwatch()
{
    setTotalTimeOfStopwatch(m_previousTimeInmsecs + m_stopwatchStartDateTime.msecsTo(QDateTime::currentDateTimeUtc()));
}

void StopwatchEngine::pauseStopwatch()
{
    setPreviousTimeOfStopwatch(m_previousTimeInmsecs + m_stopwatchStartDateTime.msecsTo(QDateTime::currentDateTimeUtc()));
    setTotalTimeOfStopwatch(m_previousTimeInmsecs);
    setRunning(false);
    m_timer.stop();
}

void StopwatchEngine::clearStopwatch()
{
    setPreviousTimeOfStopwatch(0);
    setTotalTimeOfStopwatch(0);

    beginResetModel();
    m_settings.setValue("Stopwatch/laps", QVariantList());
    endResetModel();
}

bool StopwatchEngine::running() const
{
    return m_isStopwatchRunning;
}

int StopwatchEngine::previousTimeOfStopwatch() const
{
    return m_previousTimeInmsecs;
}

int StopwatchEngine::totalTimeOfStopwatch() const
{
    return m_totalTimeInmsecs;
}

void StopwatchEngine::setRunning(bool value)
{
    if(value == m_isStopwatchRunning)
    {
        return;
    }

    m_isStopwatchRunning = value;
    m_settings.setValue("Stopwatch/isStopwatchRunning", m_isStopwatchRunning);
    emit runningChanged();
}

void StopwatchEngine::setPreviousTimeOfStopwatch(int value)
{
    if(value == m_previousTimeInmsecs)
    {
        return;
    }

    m_previousTimeInmsecs = value;
    m_settings.setValue("Stopwatch/previousTimeInmsecs", m_previousTimeInmsecs);
    emit previousTimeOfStopwatchChanged();
}

void StopwatchEngine::setTotalTimeOfStopwatch(int value)
{
    if(value == m_totalTimeInmsecs)
    {
        return;
    }

    m_totalTimeInmsecs = value;
    emit totalTimeOfStopwatchChanged();
}
