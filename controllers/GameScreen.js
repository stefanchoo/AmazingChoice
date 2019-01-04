/* This script file handles the game logic */
.import QtQuick 2.0 as Quick
.import "../controllers/EndEffect.js" as EndEffect
.import "../controllers/Circle.js" as Circle

// 定义全局唯一的对象
var screen
var gameScreenObject

// 终端对象
var endEffectObject

// 目标点指示
var circleTargetObject

var targetPoints = [] // 目标点集合

var currentTragetIndex = 0      // 当前目标点位

function createGameScreen(view, gameData) {
    screen = view    // 拿到外部对象
    gameScreenObject = new Object
    var gameScreenComponent = Qt.createComponent("../views/GameScreen.qml")
      if(gameScreenComponent.status === Quick.Component.Ready) {
         gameScreenObject = gameScreenComponent.createObject(view)
          if (gameScreenObject === null) {
              console.log("error creating combine")
              console.log(gameScreenComponent.errorString())
              return null
          }
          gameScreenObject.gameData = gameData
          gameScreenObject.x = (view.width - gameScreenObject.width) / 2
          gameScreenObject.y = (view.height - gameScreenObject.height + 50) / 2
          startNewScene()
      } else {
          console.log("error loading block component")
          console.log(gameScreenComponent.errorString())
          return null
      }
      return gameScreenObject
}

// 创建场景
function startNewScene() {

    targetPoints = []
    currentTragetIndex = 0
    endEffectObject = new Object
    circleTargetObject = new Object

    // 创建终端控件
    var endObject = Object
    endObject.x = -1000
    endObject.y = -1000
    endObject.size = 60
    endObject.bColor = "#03A9F4"
    endEffectObject = EndEffect.createEndEffect(gameScreenObject, endObject)

    for(var i=0; i<gameScreenObject.targetPoints.length; i++) {
        targetPoints.push(gameScreenObject.targetPoints[i])
    }

    //    标记出第一个目标点
    circleTargetObject = Circle.createTargetCircle(gameScreenObject, targetPoints[0])
    circleTargetObject.visible = false

    // 场景创建成功，开始游戏
    screen.twentySecondsTimer.start()
    screen.fifteenSecondsTimer.start()
}

function handleChoose() {
//    endEffectObject.value = 100
    endEffectObject.state = "moveState"
    // 加分
    screen.totalScore += 10
    createChooseAction(gameScreenObject, targetPoints[0])
    nextTargetPoint()
}

function handleChooseTimeout() {
    handleChoose()
    screen.totalScore -= 10
}

function nextTargetPoint() {
    // 移出首个点
    targetPoints.shift()
    // TODO 动画
    if (targetPoints.length !== 0) {
        currentTragetIndex++
        circleTargetObject.x = targetPoints[0][0] - (circleTargetObject.width / 2)
        circleTargetObject.y = targetPoints[0][1] - (circleTargetObject.height / 2)
        screen.fifteenSecondsTimer.start()
        screen.twentySecondsTimer.start()
        circleTargetObject.visible = false
    } else {
        screen.updateData()
    }
}


function handlePress(xPos, yPos) {
    if (!endEffectObject) {
        console.info("target object is null")
        return
    }
    if (xPos < 0)
        xPos = 0
    if (xPos > gameScreenObject.width)
        xPos = gameScreenObject.width
    if (yPos < 0)
        yPos = 0
    if (yPos > gameScreenObject.height)
        yPos = gameScreenObject.height
    endEffectObject.x = xPos - endEffectObject.width / 2
    endEffectObject.y = yPos - endEffectObject.height / 2
}

function handleTargetMatch(xPos, yPos) {
    if(targetPoints.length === 0) return
//    if(endEffectObject.state === "chooseState") return
    if (Math.abs(targetPoints[0][0] - xPos) < 50 && Math.abs(
                  targetPoints[0][1] - yPos) < 50) {
         console.debug("到达目标点 ",  currentTragetIndex)
         circleTargetObject.frequency = 500
         screen.twentySecondsTimer.stop()
         screen.fifteenSecondsTimer.stop()
         endEffectObject.state = "chooseState"
         screen.twoSecondsTimer.start()
    } else {
        // 脱离目标点，停止
        if(endEffectObject.state !== "moveState") {
            screen.twoSecondsTimer.stop()
            screen.twentySecondsTimer.start()
            circleTargetObject.frequency = 500
            screen.fifteenSecondsTimer.start()
            endEffectObject.state = "moveState"
        }
    }
}

function addOil() {
    circleTargetObject.frequency = 150
    circleTargetObject.visible = true
}


function createChooseAction(view, point) {
   var resultObject = new Object
    var resultComponent = Qt.createComponent("../views/ChooseResult.qml");
    if (resultComponent.status === Quick.Component.Ready) {
        resultObject = resultComponent.createObject(view);
        if (!resultObject) {
            console.log("error creating endeffect");
            console.log(circleComponent.errorString());
            return null;
        }
        resultObject.x = point[0];
        resultObject.y = point[1];
    } else {
        console.log("error loading endeffect component");
        console.log(resultComponent.errorString());
        return null;
    }
    return resultObject;
}


function getDevPointlist() {
    var pointlist = [];
    for( var i = 0; i < targetPoints.length; i++) {
        var x = xGame2Device(targetPoints[i][0], gameScreenObject.width);
        var y = yGame2Device(targetPoints[i][1], gameScreenObject.height);
        pointlist.push(x, y);
    }
    //console.debug("pointlist:", pointlist);
    return pointlist;
}

function xGame2Device(x, width) {
    var w = width * 1.0;
    var temp_x = ((x) - (w * 0.5) ) / w *(-1);
    return temp_x;
}

function yGame2Device(y, height) {
    var h = height * 1.0;
    var temp_y = (y) / h - 0.1;
    return temp_y;
}

