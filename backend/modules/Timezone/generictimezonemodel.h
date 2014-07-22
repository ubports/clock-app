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

#ifndef U1DBTIMEZONEMODEL_H
#define U1DBTIMEZONEMODEL_H

#include <QList>
#include <QVariant>

#include "timezonemodel.h"

class GenericTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    // Property to store the u1db query model results
    Q_PROPERTY(QList<QVariant> model
               READ model
               WRITE setModel
               NOTIFY modelChanged)

public:
    GenericTimeZoneModel(QObject *parent = 0);

    // Function to read the model
    QList<QVariant> model() const;

    // Function to set the model
    void setModel(const QList<QVariant> &model);

signals:
    // Signal to notify the change of the model to QML
    void modelChanged();

private:
    // Function to do the QList parsing
    void loadTimeZonesFromU1db();

    // Private copy of the model received from QML
    QList<QVariant> m_model;
};

#endif // U1DBTIMEZONEMODEL_H
