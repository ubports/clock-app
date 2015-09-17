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

    m_notLocalizedLocalTime = QTime::currentTime().toString("hh:mm:ss");
    m_localizedLocalTime = QTime::currentTime().toString(Qt::DefaultLocaleShortDate);
    m_localizedLocalDate = QDate::currentDate().toString(Qt::DefaultLocaleLongDate);

    m_updateTimer.setInterval(1000);
    connect(&m_updateTimer, &QTimer::timeout, this, &DateTime::update);

    m_updateTimer.start();
}

QString DateTime::notLocalizedStringOfLocalTime() const
{
    return m_notLocalizedLocalTime;
}

QString DateTime::localizedStringOfLocalTime() const
{
    return m_localizedLocalTime;
}

QString DateTime::localizedStringOfLocalDate() const
{
    return m_localizedLocalDate;
}

void DateTime::update()
{
    m_notLocalizedLocalTime = QTime::currentTime().toString("hh:mm:ss");
    emit notLocalizedStringOfLocalTimeChanged();

    m_localizedLocalTime = QTime::currentTime().toString(Qt::DefaultLocaleShortDate);
    emit localizedStringOfLocalTimeChanged();

    m_localizedLocalDate = QDate::currentDate().toString(Qt::DefaultLocaleLongDate);
    emit localizedStringOfLocalDateChanged();
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
