#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "zone.h"
#include "timezonemodel.h"
#include "xmltimezonemodel.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Timezone"));

    qmlRegisterType<Zone>(uri, 1, 0, "Zone");
    qmlRegisterType<TimeZoneModel>(uri, 1, 0, "TimeZoneModel");
    qmlRegisterType<XmlTimeZoneModel>(uri, 1, 0, "XmlTimeZoneModel");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
