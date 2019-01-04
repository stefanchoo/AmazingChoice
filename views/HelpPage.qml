import QtQuick 2.8
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "../controllers/Constants.js" as Constants

Item {
    id: root
    width: 1200
    height: 800
    z: 200

    focus: screen.state !== "running"

    Keys.onReturnPressed: startBtn.click()

    property alias startButton: startBtn
    property alias finishButton: finishBtn

    Rectangle {
        anchors.centerIn: parent
        width: 800
        height: 800
        color: "#444444"
        radius: 80
    }

    Label {
        anchors {
            top: parent.top
            topMargin: 50
            horizontalCenter: parent.horizontalCenter
        }
        text: "认知游戏"
        color: "white"
        style: "display1"
    }

    Label {
        id: operationInfo
        anchors {
            top: parent.top
            topMargin: 150
            horizontalCenter: parent.horizontalCenter
        }
        text: "1. 观察目标图形" // 2. 选择与目标一致的图形 // 3. 完成
        color: "white"
        style: "headline"
    }


    EndEffect {
        id: end
        bColor: "#03A9F4"

        x: 580
        y: 200

        state: y === 472 || y === 352 ? "chooseState" : "moveState"

        //x: 450
        //y: 352

        //x: 330
        //y: 472
    }

    ChooseResult {
        id: result1
        x: 480
        y: 380
        z: 100
        visible: false
    }

    ChooseResult {
        id: result2
        x: 360
        y: 500
        z: 100
        visible: false
    }

    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            //暂停作用
            duration: 2000
        }
        PropertyAnimation {
            target: operationInfo
            property: "text"
            to: "2. 选择与目标一致的图形"
        }
        ParallelAnimation {
            NumberAnimation {
                target: end
                property: "x"
                duration: 1000
                to: 450
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: end
                property: "y"
                duration: 1000
                to: 352
                easing.type: Easing.InOutQuad
            }
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }

        PropertyAnimation {
            target: result1
            property: "visible"
            to: "true"
        }

        ParallelAnimation {
            NumberAnimation {
                target: end
                property: "x"
                duration: 1000
                to: 330
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: end
                property: "y"
                duration: 1000
                to: 472
                easing.type: Easing.InOutQuad
            }
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }
        PropertyAnimation {
            target: result2
            property: "visible"
            to: "true"
        }
        PropertyAnimation {
            target: operationInfo
            property: "text"
            to: "3. 完成"
        }
        NumberAnimation {
            //暂停作用
            duration: 2000
        }
        ParallelAnimation {
            PropertyAnimation {
                target: operationInfo
                property: "text"
                to: "1. 观察目标图形"
            }
            NumberAnimation {
                target: end
                property: "x"
                duration: 0
                to: 580
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: end
                property: "y"
                duration: 0
                to: 200
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: result1
                property: "visible"
                to: "false"
            }
            PropertyAnimation {
                target: result2
                property: "visible"
                to: "false"
            }
        }
    }

    Item {
        width: parent.width * 0.4
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.15

        View {
            id: targetView
            width: parent.width
            height: parent.height * 0.2
            anchors {
                top: parent.top
                topMargin: 180
                horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: targetName
                width: 100
                anchors {
                    left: parent.left
                    leftMargin: 145
                    verticalCenter: parent.verticalCenter
                }
                text: Constants.getTypeData(screen.sceneType).ch_list[5]
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
                source: Constants.getTypeData(
                            screen.sceneType).path_prefix + Constants.getTypeData(
                            screen.sceneType).en_list[5] + ".png"
            }
        }
        View {
            id: selectView
            width: 220
            height: parent.height * 0.6
            anchors {
                top: targetView.top
                topMargin: 150
                horizontalCenter: parent.horizontalCenter
            }

            Flow {
                anchors.fill: parent
                spacing: 20

                Repeater {
                    model: 4
                    delegate: Item {
                        width: 100
                        height: width
                        Icon {
                            name: "shape/rectangle"
                            color: "#DDDDDD"
                            size: 100
                        }
                        Image {
                            anchors.centerIn: parent
                            source: getSource(index)

                            function getSource(index) {
                                var src = ""
                                if (index === 1 || index === 2)
                                    src = Constants.getTypeData(
                                                screen.sceneType).path_prefix
                                            + Constants.getTypeData(
                                                screen.sceneType).en_list[5] + ".png"
                                else
                                    src = Constants.getTypeData(
                                                screen.sceneType).path_prefix
                                            + Constants.getTypeData(
                                                screen.sceneType).en_list[index] + ".png"
                                return src
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        width: parent.width * 0.4
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.15
        GameButton {
            id: startBtn
            text: "开始游戏"
            anchors {
                top: parent.top
                topMargin: 260
                horizontalCenter: parent.horizontalCenter
            }
            onClick: {
                if (screen.state == "pause")
                    screen.continued()
                else
                    screen.started()
            }
        }

        GameButton {
            id: finishBtn
            text: "结束游戏"
            enabled: screen.state === "pause"
            anchors {
                bottom: parent.bottom
                bottomMargin: 260
                horizontalCenter: parent.horizontalCenter
            }
            onClick: screen.finished()
        }
    }
}
