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

#ifndef HISTORY_H
#define HISTORY_H

#include <QAbstractListModel>
#include <QSettings>

class LapHistory : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Role {
        RoleTotalTime,
        RoleDiffToPrevious
    };

    explicit LapHistory(QObject *parent = 0);

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

public slots:
    // Function to add a stopwatch lap
    void addLap(int timeDiff);

    // Function to remove a stopwatch lap
    void removeLap(int lapIndex);

    // Function to clear all stopwatch laps
    void clear();

private:
    QSettings m_settings;
};

#endif // HISTORY_H
