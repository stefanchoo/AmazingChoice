import QtQuick 2.8
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem

Rectangle {
    id: root
    property int graphBlockSize: 100
    property string graphColor: "#DDDDDD"
    property var gameData: Object
    property var targetPoints: gameData.target_point_list
    property var number: gameData.select_list_path.length

    width: 1200
    height: 800
    color: "#666666"

    View {
        id: targetView
        width: 700
        height: 100
        anchors {
            top: parent.top
            topMargin: (30 - number) * 120 / 6
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: targetName
            width: 100
            anchors {
                left: parent.left
                leftMargin: 250
                verticalCenter: parent.verticalCenter
            }
            text: gameData.target_name
            style: "display1"
            color: "white"
        }

        Image {
            anchors {
                left: targetName.right
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
            scale: 1.1
            source: gameData.target_path
        }
    }

    View {
        id: selectView
        width: 700
        height: 610
        anchors {
            top: targetView.top
            topMargin: 120
            horizontalCenter: parent.horizontalCenter
        }

        Flow {
            anchors.fill: parent
            spacing: 20

            Repeater {
                model: number
                delegate: Item {
                    width: graphBlockSize
                    height: width
                    Icon {
                        name: "shape/rectangle"
                        color: graphColor
                        size: graphBlockSize
                    }
                    Image {
                        anchors.centerIn: parent
                        source: gameData.select_list_path[index]
                    }
                }
            }
        }
    }
}
