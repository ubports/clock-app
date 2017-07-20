/*****************************************************************************
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
#include <QDebug>

TimerEngine::TimerEngine(QObject *parent) : QAbstractListModel(parent) {

    if(m_isTimerRunning == true) {
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

    return 0;// m_settings.value("Timer/timers").toList().count();
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
}

void TimerEngine::updateTimer() {
}

void TimerEngine::pauseTimer() {
    setRunning(false);
}

void TimerEngine::clearTimer() {
    beginResetModel();
    endResetModel();
}

bool TimerEngine::running() const {
    return m_isTimerRunning;
}


void TimerEngine::setRunning(bool value) {
    if(value == m_isTimerRunning) {
        return;
    }

    m_isTimerRunning = value;
    emit runningChanged();
}
