/*
 * Copyright (C) 2014-2015 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QDateTime>

#include "datetime.h"

DateTime::DateTime(QObject *parent) :
    QObject(parent)
{
    // Initialise the date and time at start rather than wait for a sec to do so.
    m_localtime = QDateTime::currentDateTime().toString("hh:mm:ss:z");
    m_localdate = QDateTime::currentDateTime().toString("yyyy:M:d");

    m_updateTimer.setInterval(1000);
    connect(&m_updateTimer, &QTimer::timeout, this, &DateTime::update);

    m_updateTimer.start();
}

QString DateTime::localTimeString() const
{
    return m_localtime;
}

QString DateTime::localDateString() const
{
    return m_localdate;
}

void DateTime::update()
{
    m_localtime = QDateTime::currentDateTime().toString("hh:mm:ss:z");
    emit localTimeStringChanged();

    m_localdate = QDateTime::currentDateTime().toString("yyyy:M:d");
    emit localDateStringChanged();
}

int DateTime::updateInterval() const
{
    return m_updateTimer.interval();
}

void DateTime::setUpdateInterval(int updateInterval)
{
    if (m_updateTimer.interval() != updateInterval) {
        m_updateTimer.setInterval(updateInterval);
        emit updateIntervalChanged();

        if (m_updateTimer.interval() > 0) {
            m_updateTimer.start();
        }
        else {
            m_updateTimer.stop();
        }
    }
}
