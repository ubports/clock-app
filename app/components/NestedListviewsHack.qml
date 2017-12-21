import QtQuick 2.4

/**
 * HACK : This is an hack to reduce the cases the swiping left/right on a lap might switch between the main view pages
 *       (This a QT issue when you have nested interactive listviews)
 *       (This implementation require the list to have an header that is the same hight as it`s items)
 */


Item {
    anchors.fill: parent
    property ListView nestedListView : null
    property ListView parentListView : null

    function release() {
        parentListView.interactive = true;
    }

    MouseArea {
        z:10
        id:aboveNestedList
        height:nestedListView.y
        anchors {
            top: parent.top
            left:parent.left
            right:parent.right
        }
        propagateComposedEvents: true
        preventStealing: mouseFlickHack.preventFlick
        onPressed: { parentListView.interactive = true ; mouse.accepted = false }
    }
    MouseArea {
        z:10
        id:mouseFlickHack

        property bool preventFlick: nestedListView.visible
        anchors {
            top:aboveNestedList.bottom
            left: parent.left
            right: parent.right
        }
        height : Math.min(  nestedListView.height,
                            Math.max( nestedListView.headerItem ? (1+nestedListView.count) * nestedListView.headerItem.height : 0 ,
                                      nestedListView.count && nestedListView.itemAt(0,0) ? (1+nestedListView.count) * nestedListView.itemAt(0,0).height : 0 )
                 )
        hoverEnabled:true
        propagateComposedEvents: true
        preventStealing: preventFlick
        onPressed: { parentListView.interactive = !preventFlick ; mouse.accepted = false }
        onEntered: parentListView.interactive = !preventFlick
        onExited: parentListView.interactive = true
        onReleased: { parentListView.interactive = true ; mouse.accepted = false }

    }
    MouseArea {
        z:10
        id:undersNestedList
        anchors {
            top:mouseFlickHack.bottom
            left: mouseFlickHack.left
            right: mouseFlickHack.right
            bottom: parent.bottom
        }

        propagateComposedEvents: true
        preventStealing: mouseFlickHack.preventFlick
        onPressed: { parentListView.interactive = true ; mouse.accepted = false }
    }
}
