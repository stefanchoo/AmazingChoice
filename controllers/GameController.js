.import QtQuick 2.0 as Quick
.import "GameScreen.js" as GameScreen
.import "Constants.js" as Constants

var gameCanvas
var endEffectObject

function start() {
    console.debug("游戏开始")
    gameCanvas = GameScreen.createGameScreen(screen, createGameData(screen.sceneType, screen.columnNum))
}


function levelUp() {
    console.info("level up ...")
    screen.level++
    screen.columnNum++
    GameScreen.endEffectObject.destroy()
    GameScreen.gameScreenObject.destroy()
    gameCanvas = new Object
    gameCanvas = GameScreen.createGameScreen(screen, createGameData(screen.sceneType, screen.columnNum))
}


function updateData() {
   console.info("update data ...")
   screen.updateTimes++
   GameScreen.endEffectObject.destroy()
   GameScreen.gameScreenObject.destroy()
   gameCanvas = new Object
   gameCanvas = GameScreen.createGameScreen(screen, createGameData(screen.sceneType, screen.columnNum))
}


function updateScene() {
    console.info("update scene ...")
    GameScreen.endEffectObject.destroy()
    GameScreen.gameScreenObject.destroy()
    gameCanvas = new Object
    gameCanvas = GameScreen.createGameScreen(screen, createGameData(screen.sceneType, screen.columnNum))
}

function handlePress(xPos, yPos) {
    GameScreen.handlePress(xPos, yPos)
}

function handleTargetMatch(xPos, yPos) {
    GameScreen.handleTargetMatch(xPos, yPos)
}

function handleMatchTimeout() {
     GameScreen.handleChoose()
     GameScreen.circleTargetObject.frequency = 500
}

function handleTouchTimeout() {
    GameScreen.circleTargetObject.frequency = 500
    GameScreen.handleChooseTimeout()
}


function createGameData(sceneType, columnNum) {
    var gameData = Object
    switch(sceneType) {
    case "shape":  gameData = Constants.randomData(Constants.shape_path_prefix,
                                                   Constants.en_shape_list,
                                                   Constants.ch_shape_list, columnNum * 6)
        break
    case "animal": gameData = Constants.randomData(Constants.animal_path_prefix,
                                                   Constants.en_animal_list,
                                                   Constants.ch_animal_list, columnNum * 6)
        break
    case "fruit": gameData = Constants.randomData(Constants.fruit_path_prefix,
                                                   Constants.en_fruit_list,
                                                   Constants.ch_fruit_list, columnNum * 6)
        break
    }

    return gameData
}

// 15s 计时到，显示加油标志
function addOil() {
    GameScreen.addOil()
}
