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

#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "timezonemodel.h"
#include "generictimezonemodel.h"
#include "jsontimezonemodel.h"
#include "statictimezonemodel.h"

void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("Timezone"));

    qmlRegisterType<GenericTimeZoneModel>(uri, 1, 0, "GenericTimeZoneModel");
    qmlRegisterType<JsonTimeZoneModel>(uri, 1, 0, "JsonTimeZoneModel");
    qmlRegisterType<StaticTimeZoneModel>(uri, 1, 0, "StaticTimeZoneModel");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
