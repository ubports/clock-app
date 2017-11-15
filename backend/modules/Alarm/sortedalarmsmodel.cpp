/*
 * Copyright (C) 2015-2016 Canonical Ltd
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

#include <QDir>
#include <QFileInfo>
#include <QStandardPaths>
#include <QMessageLogger>

#include "sortedalarmsmodel.h"


SortedAlarmsModel::SortedAlarmsModel(QObject *parent):
                   QSortFilterProxyModel(parent)
{
}

/*!
 * \qmlproperty QAbstractItemModel SortFilterModel::model
 *
 * The source model to sort and/ or filter.
 */
void SortedAlarmsModel::setModel(QAbstractItemModel *itemModel)
{
    if (itemModel == NULL) {
        return;
    }

    if (itemModel != sourceModel()) {
        if (sourceModel() != NULL) {
            sourceModel()->disconnect(this);
        }

        setSourceModel(itemModel);

        Q_EMIT modelChanged();
    }
}

void SortedAlarmsModel::setSortOrder( Qt::SortOrder order ) {
    bool orderChanged = this->sortOrder() != order;
    this->sort(this->sortRole(),order);
    if( orderChanged ) {
        Q_EMIT sortOrderChanged();
    }
}

int SortedAlarmsModel::count()
{
    return rowCount();
}

bool SortedAlarmsModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QObject* leftData = left.data(Qt::InitialSortOrderRole).value<QObject*>();
    QObject* rightData = right.data(Qt::InitialSortOrderRole).value<QObject*>();
    qint32 decreaseDisabled = 0x0FFFFFFF; // TODO find out the max positive int32 c++ value constant name.
    QDateTime currentDateTime = QDateTime::currentDateTime();
    qint64 leftValue = (currentDateTime < leftData->property("date").toDateTime() ? 0 : decreaseDisabled) + floor(leftData->property("date").toDateTime().toTime_t()) + (leftData->property("enabled").toBool() ? -0.1 : 0);
    qint64 rightValue = (currentDateTime < rightData->property("date").toDateTime() ? 0 : decreaseDisabled) + floor(rightData->property("date").toDateTime().toTime_t())+ (rightData->property("enabled").toBool() ? -0.1 : 0);

    return leftValue < rightValue;
}
