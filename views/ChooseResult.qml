import QtQuick 2.8
import Material 0.2
import Material.ListItems 0.1 as ListItem

Item {
    width: 50
    height: 50
    Rectangle {
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 20
    }
    Icon {
        id: icon
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        name: "info/right"
        color: "#2196F3"
        size: 48
    }
}
