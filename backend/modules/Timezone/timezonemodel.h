#ifndef TIMEZONEMODEL_H
#define TIMEZONEMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QUrl>
#include <QTimer>

// Create a simple container class to hold our information
class TimeZone
{
public:
    QString cityName;
    QString country;
    QString timeZoneId;
};



// We're going to use QAbstractListModel as the base class
// That makes it compatible to QML's ListView.
class TimeZoneModel: public QAbstractListModel
{
    Q_OBJECT

    // Let's have a source property for the xml file, just like the XmlListModel
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)

    // A this property determines the interval for updating time. The default, 0, doesn't update at all
    Q_PROPERTY(int updateInterval READ updateInterval WRITE setUpdateInterval NOTIFY updateIntervalChanged)

public:
    enum Roles {
        RoleCityName,
        RoleCountyName,
        RoleTimeZoneId,
        RoleTimeString
    };

    // A simple constructor. Add the standard QObject *parent parameter.
    // That helps Qt with "garbage collection"
    TimeZoneModel(QObject *parent = 0);

    // Let's override the pure virtual functions (the ones marked as
    // "virtual" and have "= 0" in the end.
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    // As QML can't really deal with the Roles enum above, we need a mapping
    // between the enum and strings
    QHash<int, QByteArray> roleNames() const override;

    // We need to implement the READ and WRITE methods of the properties
    QUrl source() const;
    void setSource(const QUrl &source);

    int updateInterval() const;
    void setUpdateInterval(int updateInterval);

signals:
    // and we need a signal for the NOTIFY when the properties change
    void sourceChanged();
    void updateIntervalChanged();

private:
    // Lets do the xml parsing in a separate function for less messy code
    void loadTimeZonesFromXml();

private slots:
    // A private slot that gets called by the updateTimer
    void update();

private:
    // Keep a list of TimeZone objects, holding all our timeZones.
    QList<TimeZone> m_timeZones;

    // And keel a store of the source property
    QUrl m_source;

    // Have a timer to update stuff
    QTimer m_updateTimer;
};

#endif
