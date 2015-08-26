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

#ifndef GENERICTIMEZONEMODEL_H
#define GENERICTIMEZONEMODEL_H

#include <QList>
#include <QVariant>

#include "timezonemodel.h"

class GenericTimeZoneModel : public TimeZoneModel
{
    Q_OBJECT

    // Property to store the u1db query model results
    Q_PROPERTY(QList<QVariant> results
               READ results
               WRITE setResults
               NOTIFY resultsChanged)

public:
    GenericTimeZoneModel(QObject *parent = 0);

    // Function to read the model
    QList<QVariant> results() const;

    // Function to set the model
    void setResults(const QList<QVariant> &results);

signals:
    // Signal to notify the change of the model to QML
    void resultsChanged();

private:
    // Function to do the QList parsing
    void loadTimeZonesFromVariantList();

    // Private copy of the model received from QML
    QList<QVariant> m_results;
};

#endif // GENERICTIMEZONEMODEL_H
