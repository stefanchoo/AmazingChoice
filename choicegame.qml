import QtQuick 2.8
import QtQuick.Controls 2.2
import Material 0.2
import Material.ListItems 0.1 as ListItem
import "images"
import "views"
import "controllers/GameController.js" as GameControl

Window {
    id: root
    visible: true

    width: 1920
    height: 1032

    Rectangle {
        id: screen
        width: 1920
        height: 1032
        color: "#666666"

        property int updateTimes: 0
        property int level: 1
        property int columnNum: 1
        property int bestScore: 1960
        property int totalScore: 0
        property int secondRemain: 600
        property int pauseCount: 0
        property string sceneType: "shape"

        property var sceneTypes: ["shape", "animal", "fruit"]

        property int actionScore: 0
        property string state: "idle" // 游戏的状态  idle running pause finished
        property alias levelUpAction: levelUpImg
        property alias oneSecondsTimer: oneSeconds
        property alias threeSecondsTimer: threeSeconds
        property alias twoSecondsTimer: twoSeconds
        property alias twentySecondsTimer: twentySeconds
        property alias fifteenSecondsTimer: fifteenSeconds

        signal started
        signal paused
        signal continued
        signal finished
        signal updateData
        signal levelUp

        onSceneTypeChanged: GameControl.updateScene()

        onBestScoreChanged: {
            infoBar.bestScoreView.style = "display1"
            actionTimer.start()
        }

        onTotalScoreChanged: {
            infoBar.scoreView.style = "display3"
            actionTimer.start()
            if (totalScore > bestScore)
                bestScore = totalScore
        }

        onSecondRemainChanged: {
            if (secondRemain <= 10) {
                infoBar.timeView.style = "display3"
                actionTimer.start()
            }
        }

        onUpdateData: {
            oneSecondsTimer.start()
        }

        onLevelUp: {
            infoBar.levelView.style = "display2"
            actionTimer.start()
            state = "running"
            GameControl.levelUp()
        }

        onStarted: {
            helpPage.visible = false
            infoBar.visible = true
            GameControl.start()
            state = "running"
        }

        onPaused: {
            state = "pause"
            pauseCount++
            helpPage.startButton.text = "继续游戏"
            helpPage.visible = true
            fifteenSecondsTimer.stop()
            twentySecondsTimer.stop()
        }

        onContinued: {
            helpPage.visible = false
            state = "running"
            fifteenSecondsTimer.start()
            twentySecondsTimer.start()
        }

        onFinished: {
            helpPage.visible = false
            state = "finished"
            levelUpImg.levelInfo = "游戏结束"
            levelUpImg.visible = true
            twoSecondsTimer.stop()
            threeSecondsTimer.stop()
            fifteenSecondsTimer.stop()
            twentySecondsTimer.stop()
        }

        // levelUp
        Timer {
            id: threeSeconds
            interval: 3000
            repeat: false
            running: false
            onTriggered: {
                levelUpImg.visible = false
                screen.levelUp()
            }
        }

        Timer {
            id: twoSeconds
            interval: 2000
            repeat: false
            running: false
            onTriggered: {
                GameControl.handleMatchTimeout()
            }
        }

        Timer {
            id: oneSeconds
            interval: 1000
            repeat: false
            running: false
            onTriggered: {
                if(screen.state !== "running") {
                    oneSeconds.start()
                    return
                }
                if (screen.level < 5 && screen.updateTimes === 4) {
                    screen.updateTimes = 0
                    screen.levelUpAction.visible = true
                    screen.threeSecondsTimer.start()
                    screen.state = "pause"
                } else {
                    GameControl.updateData()
                }
            }
        }

        Timer {
            id: twentySeconds
            interval: 20000
            repeat: false
            running: false
            onTriggered: {
                GameControl.handleTouchTimeout()
            }
        }

        Timer {
            id: fifteenSeconds
            interval: 15000
            repeat: false
            running: false
            onTriggered: {
                GameControl.addOil()
            }
        }

        InfoBar {
            id: infoBar
            width: parent.width
            visible: false

            Timer {
                id: actionTimer
                running: false
                interval: 500
                onTriggered: {
                    infoBar.timeView.style = "display2"
                    infoBar.scoreView.style = "display2"
                    infoBar.bestScoreView.style = "headline"
                    infoBar.levelView.style = "display1"
                }
            }
        }

        ListView {
            id: sceneView
            visible: screen.state === "running"
            width: 300
            height: 660
            anchors {
                top: parent.top
                topMargin: 200
                left: parent.left
                leftMargin: 50
            }
            highlight: Rectangle {
                color: "#444444"
                radius: 30
            }
            highlightFollowsCurrentItem: true
            model: screen.sceneTypes
            spacing: 30
            delegate: Item {
                width: 200
                height: 200

                Label {
                    anchors {
                        top: parent.top
                        topMargin: 25
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: getText(index)
                    style: "headline"
                    color: sceneView.currentIndex === index ? "white" : "#999999"

                    function getText(index) {
                        var txt = ""
                        switch (index) {
                        case 0:
                            txt = "形状场景"
                            break
                        case 1:
                            txt = "动物场景"
                            break
                        case 2:
                            txt = "水果场景"
                            break
                        }
                        return txt
                    }
                }

                Icon {
                    anchors {
                        top: parent.top
                        topMargin: 80
                        horizontalCenter: parent.horizontalCenter
                    }
                    name: getName(index)
                    size: 100
                    color: sceneView.currentIndex === index ? "white" : "#999999"
                    function getName(index) {
                        var txt = ""
                        switch (index) {
                        case 0:
                            txt = "shape/multi"
                            break
                        case 1:
                            txt = "shape/animal"
                            break
                        case 2:
                            txt = "shape/fruit"
                            break
                        }
                        return txt
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sceneView.currentIndex = index
                        console.debug("sceneType=", sceneView.currentIndex)
                        screen.sceneType = screen.sceneTypes[sceneView.currentIndex]
                    }
                }
            }
        }

        Item {
            id: levelUpImg
            width: 1200
            height: 800
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2
            z: 200
            visible: false
            property alias levelInfo: infomation.text

            focus: screen.state === "finished"

            Keys.onReturnPressed: quitBtn.clicked()

            Rectangle {
                anchors.fill: parent
                radius: 30
                color: "black"
                opacity: 0.5
            }

            IconButton {
                id: quitBtn
                anchors {
                    top: parent.top
                    topMargin: 50
                    right: parent.right
                    rightMargin: 50
                }
                enabled: screen.state === "finished"
                visible: enabled
                size: 50
                color: "white"
                iconName: "info/back"
                onClicked: {
                    // TODO 发送销毁游戏的信号
                    console.info("Quit Game")
                    Qt.quit()
                }
            }

            Row {
                width: 600
                height: 300
                anchors {
                    top: parent.top
                    topMargin: 150
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: 10
                Repeater {
                    model: 8
                    Emitter {
                        anchors.top: parent.top
                        anchors.topMargin: Math.random(1) * 200
                    }
                }
            }

            Icon {
                name: "shape/crown"
                color: "#FFC100"
                size: 180
                anchors.centerIn: parent
            }
            Label {
                id: infomation
                text: "升级了"
                anchors {
                    top: parent.top
                    topMargin: 500
                    horizontalCenter: parent.horizontalCenter
                }
                color: "#FFC100"
                style: "display1"
            }

            Label {
                id: totalScoreLabel
                text: (screen.state === "finished") ? screen.actionScore : screen.totalScore
                anchors {
                    top: parent.top
                    topMargin: 300
                    right: parent.right
                    rightMargin: 120
                }
                color: "white"
                style: "display4"
            }

            Label {
                text: "最高分：" + screen.bestScore
                anchors {
                    top: parent.top
                    topMargin: 480
                    horizontalCenter: totalScoreLabel.horizontalCenter
                }
                color: "white"
                style: "display1"
            }
        }

        View {
            id: mouseArea
            width: 1200
            height: 800
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2

            MouseArea {
                anchors.fill: parent
                onPositionChanged: {
                    if (screen.state !== "running")
                        return
                    GameControl.handlePress(mouse.x, mouse.y)
                    GameControl.handleTargetMatch(mouse.x, mouse.y)
                }
            }
        }
        // 需要一张图片作为帮助文档
        HelpPage {
            id: helpPage
            x: (parent.width - width) / 2
            y: (parent.height - height + 50) / 2
        }
    }

    Timer {
        id: timeLeft
        repeat: true
        running: screen.state === "running"
        interval: 1000
        onTriggered: {
            screen.secondRemain--
            if (screen.secondRemain === 0) {
                running = false
                screen.finished()
            }
        }
    }

    Timer {
        id: scoreTimer
        repeat: true
        running: screen.state === "finished"
        interval: 3
        onTriggered: {
            screen.actionScore += 5
            if (screen.actionScore >= screen.totalScore) {
                screen.actionScore = screen.totalScore
                running = false
            }
        }
    }
}
