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

#ifndef FORMATTIME_H
#define FORMATTIME_H

#include <QObject>

class FormatTime: public QObject
{
    Q_OBJECT

public:
    FormatTime(QObject *parent=0);

    Q_INVOKABLE QString millisToString(int millis) const;
    Q_INVOKABLE QString millisToTimeString(int millis, bool showHours) const;
    Q_INVOKABLE QString addZeroPrefix(QString str, int totalLength) const;
    Q_INVOKABLE QString lapTimeToString(int millis) const;
};

#endif
