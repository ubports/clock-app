/*****************************************************************************
 * Copyright: 2015 Michael Zanetti <michael_zanetti@gmx.net>                 *
 *                                                                           *
 * This file is part of ubuntu-authenticator                                 *
 *                                                                           *
 * This prject is free software: you can redistribute it and/or modify       *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, either version 3 of the License, or         *
 * (at your option) any later version.                                       *
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

#include "history.h"

#include <QStandardPaths>
#include <iostream>

LapHistory::LapHistory(QObject *parent) :
    QAbstractListModel(parent),
    m_settings(QStandardPaths::standardLocations(QStandardPaths::ConfigLocation).first() + "/com.ubuntu.clock/com.ubuntu.clock.stopwatch.conf", QSettings::IniFormat)
{
    std::cout << "loading laps" << m_settings.fileName().toStdString() << std::endl;
}

int LapHistory::rowCount(const QModelIndex &parent) const
{
    return m_settings.value("laps").toList().count();
}

int LapHistory::count() const
{
    return m_settings.value("laps").toList().count();
}

QVariant LapHistory::data(const QModelIndex &index, int role) const
{
    switch (role) {
    case RoleTime:
        return m_settings.value("laps").toList().at(index.row());
    case RoleDiffToPrevious: {
        int previous = index.row() == 0 ? 0 : data(this->index(index.row() - 1), RoleTime).toInt();
        return m_settings.value("laps").toList().at(index.row()).toInt() - previous;
    }
    case RoleDelta: {
        int previousTimeDiff = index.row() == 0 ? 0 : data(this->index(index.row() - 1), RoleDiffToPrevious).toInt();
        int thisTimeDiff = data(this->index(index.row()), RoleDiffToPrevious).toInt();
        return thisTimeDiff - previousTimeDiff;
    }
    }
    return QVariant();
}

QHash<int, QByteArray> LapHistory::roleNames() const
{
    QHash< int, QByteArray> roles;
    roles.insert(RoleTime, "totaltime");
    roles.insert(RoleDiffToPrevious, "laptime");
    roles.insert(RoleDelta, "delta");
    return roles;
}

void LapHistory::addLap(int timeDiff)
{
    QVariantList laps = m_settings.value("laps").toList();
    beginInsertRows(QModelIndex(), 0, 0);
    laps.prepend(timeDiff);
    m_settings.setValue("laps", laps);
    endInsertRows();
}

void LapHistory::clear()
{
    beginResetModel();
    m_settings.setValue("laps", QVariantList());
    endResetModel();
}
