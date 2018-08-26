/*****************************************************************************
 * Copyright: 2015-2016 Michael Zanetti <michael_zanetti@gmx.net>            *
 *            2015-2016 Bartosz Kosiorek <gang65@poczta.onet.pl>             *
 *                                                                           *
 * This prject is free software: you can redistribute it and/or modify       *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation, version 3 of the License.                   *
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

#ifndef SORTED_ALARMS_MODEL_H
#define SORTED_ALARMS_MODEL_H

#include <QtCore/QSortFilterProxyModel>
#include <QTimer>
#include <QSettings>
#include <QDateTime>



class SortedAlarmsModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* model READ sourceModel WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)

public:
     explicit SortedAlarmsModel(QObject *parent = 0);
     void setModel(QAbstractItemModel *model);
     int count();
     void setSortOrder(Qt::SortOrder  order);

Q_SIGNALS:
    void countChanged();
    void modelChanged();
    void sortOrderChanged();

protected:
     bool lessThan(const QModelIndex &left, const QModelIndex &right) const;



};

#endif // SORTED_ALARMS_MODEL_H
