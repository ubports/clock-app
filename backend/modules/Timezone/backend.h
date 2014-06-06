#ifndef BACKEND_PLUGIN_H
#define BACKEND_PLUGIN_H

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlExtensionPlugin>

/*
 ----8<-----

 import Timezone 1.0

 Rectangle {
   width: 200
   height: 200

   Timezone {
      id: timezone
   }

   Text {
     anchors.centerIn: parent
     text: timezone.helloworld
   }
 }

 -----8<------
*/
class BackendPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
};
#endif // BACKEND_PLUGIN_H

