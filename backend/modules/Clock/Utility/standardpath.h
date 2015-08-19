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

#ifndef STANDARDPATH_H
#define STANDARDPATH_H

#include <QObject>

class StandardPath: public QObject
{
    Q_OBJECT

    // READONLY Property to return the app data directory path
    Q_PROPERTY( QString appDirectory
                READ appDirectory)

public:
    StandardPath(QObject *parent = 0);

    // Function to return the app data directory path
    QString appDirectory() const;
};

#endif
