#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "zone.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Timezone"));

    qmlRegisterType<Zone>(uri, 1, 0, "Zone");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
