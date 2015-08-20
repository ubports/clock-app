/*
 * Copyright (C) 2015 Canonical Ltd
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

#include "history.h"

#include <QStandardPaths>
#include <QDebug>

LapHistory::LapHistory(QObject *parent) :
    QAbstractListModel(parent),
    /*
     #FIXME: Change QStandardPaths::ConfigLocation to QStandardPaths::AppConfigLocation
     when Ubuntu Touch moves over to Qt 5.5. AppConfigLocation will directly return
     /home/phablet/.config/com.ubuntu.clock path.
    */
    m_settings(QStandardPaths::standardLocations(QStandardPaths::ConfigLocation).first() + "/com.ubuntu.clock/com.ubuntu.clock.conf", QSettings::IniFormat)
{
    qDebug() << "[LOG] Loading laps from " << m_settings.fileName();
}

int LapHistory::rowCount(const QModelIndex &parent) const
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

int LapHistory::count() const
{
    return m_settings.value("Stopwatch/laps").toList().count();
}

QVariant LapHistory::data(const QModelIndex &index, int role) const
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

QHash<int, QByteArray> LapHistory::roleNames() const
{
    QHash< int, QByteArray> roles;
    roles.insert(RoleTotalTime, "totaltime");
    roles.insert(RoleDiffToPrevious, "laptime");
    return roles;
}

void LapHistory::addLap(int timeDiff)
{
    QVariantList laps = m_settings.value("Stopwatch/laps").toList();
    beginInsertRows(QModelIndex(), 0, 0);
    laps.prepend(timeDiff);
    m_settings.setValue("Stopwatch/laps", laps);
    endInsertRows();
}

void LapHistory::clear()
{
    beginResetModel();
    m_settings.setValue("Stopwatch/laps", QVariantList());
    endResetModel();
}
