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

TimerEngine::TimerEngine(QObject *parent) : QAbstractListModel(parent),
    /*
     #FIXME: Change QStandardPaths::ConfigLocation to QStandardPaths::AppConfigLocation
     when Ubuntu Touch moves over to Qt 5.5. AppConfigLocation will directly return
     /home/phablet/.config/com.ubuntu.clock path.
    */
    m_settings(QStandardPaths::standardLocations(QStandardPaths::ConfigLocation).first() + "/com.ubuntu.clock/com.ubuntu.clock.conf", QSettings::IniFormat)
{
    qDebug() << "[LOG] Loading Saved timers from " << m_settings.fileName();

    m_timer.setInterval(45);
    connect(&m_timer, &QTimer::timeout, this, &TimerEngine::updateTimer);



    m_isTimerRunning = m_settings.value("Timer/isTimerRunning").toBool();


    if(m_isTimerRunning == true)
    {
        m_timer.start();
    }
}

int TimerEngine::rowCount(const QModelIndex &parent) const
{
    /*
     QT's models also handle tables and tree views, so the index is not just a
     integer but consists of a parent, row and a column. Since we using a simple
     list model, let's ignore the parent. Q_UNUSED(parent) gets rid of the
     compiler warning about the unused variable.
    */
    Q_UNUSED(parent)

    return m_settings.value("Timer/laps").toList().count();
}

QVariant TimerEngine::data(const QModelIndex &index, int role) const
{
    return QVariant();
}

void TimerEngine::addTimer(int timesec, QString timerName) {

}

void TimerEngine::removeTimer(int timerIndex) {

}

void TimerEngine::startTimer(int timesec) {
    setRunning(true);
    m_timer.start();
}

void TimerEngine::updateTimer() {
}

void TimerEngine::pauseTimer() {
    setRunning(false);
    m_timer.stop();
}

void TimerEngine::clearTimer() {
    beginResetModel();
    m_settings.setValue("Timer/laps", QVariantList());
    endResetModel();
}

bool TimerEngine::running() const {
    return m_isTimerRunning;
}


void TimerEngine::setRunning(bool value) {
    if(value == m_isTimerRunning)
    {
        return;
    }

    m_isTimerRunning = value;
    m_settings.setValue("Timer/isTimerRunning", m_isTimerRunning);
    emit runningChanged();
}
