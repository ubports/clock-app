/*
 * Copyright (C) 2014 Canonical Ltd
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

#ifndef JSONTIMEZONEMODEL_H
#define JSONTIMEZONEMODEL_H

#include <QUrl>

#include "timezonemodel.h"

class JsonTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    Q_PROPERTY(QUrl source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)

public:
    JsonTimeZoneModel(QObject *parent = 0);

    QUrl source() const;

    void setSource(const QUrl &source);

signals:
    void sourceChanged();

private:
    QUrl m_source;

    void loadTimeZonesFromJson();
};

#endif // JSONTIMEZONEMODEL_H
