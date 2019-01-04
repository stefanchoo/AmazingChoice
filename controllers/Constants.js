var shape_path_prefix = "../images/shape/"

var fruit_path_prefix = "../images/fruit/"

var animal_path_prefix = "../images/animal/"

var en_shape_list = ["triangle", "rectangle", "square", "trapezoid", "pentagon", "pentagram", "hexgoal", "quincunx", "circle", "half_circle", "eclipse", "peach", "selector"]

var ch_shape_list = ["三角形", "长方形", "正方形", "梯形", "五边形", "五角星", "六边形", "梅花形", "圆形", "半圆形", "椭圆形", "桃心形", "扇形"]

var en_fruit_list = ["apple", "banana", "cherry", "grape", "jujube", "kiwifruit", "orange", "peach", "pear", "pineapple", "pomegranate", "strawberry", "watermelon"]

var ch_fruit_list = ["苹果", "香蕉", "樱桃", "葡萄", "枣子", "猕猴桃", "橘子", "桃子", "梨子", "菠萝", "石榴", "草莓", "西瓜"]

var en_animal_list = ["butterfly", "dog", "elephant", "fish", "frog", "giraffe", "lion", "monkey", "mouse", "pig", "rabbit", "roster", "snake"]

var ch_animal_list = ["蝴蝶", "狗", "大象", "鱼", "青蛙", "长颈鹿", "狮子", "猴子", "老鼠", "猪", "兔子", "公鸡", "蛇"]

var points = []

function randomData(path, en_list, ch_list, number) {
    var gameData = Object
    var random_list = []
    var hash = [] // 哈希数组
    for (var i = 0; i < number; i++) {
        var random_number = Math.round(Math.random(0, 1) * (en_list.length - 1))
        random_list.push(path + en_list[random_number] + ".png")
        if (!hash[random_number])
            hash[random_number] = 1
        else
            hash[random_number]++
    }
    var max = 0 // 出现最多的次数
    var maxV // 出现最多的元素
    hash.forEach(function (item, index) {
        if (item > max) {
            max = item
            maxV = index
        }
    })
    var taget_number_list = []
    for (var j = 0; j < number; j++) {
        if (random_list[j] === (path + en_list[maxV] + ".png")) {
            taget_number_list.push(caculateTargetPoints(Math.floor(number / 6) ,j))
        }
    }
    gameData.target_name = ch_list[maxV]
    gameData.target_path = path + en_list[maxV] + ".png"
    gameData.select_list_path = random_list
    gameData.target_point_list = taget_number_list
    return gameData
}

function caculateTargetPoints(column, number) {
    var x = 300 + (number % 6) * 120
    var y = 170 + (5 - column) * 120 + Math.floor(number / 6) * 120
    return [x, y]
}


function getTypeData(shape) {
    var typeDataSrc = Object
    switch(shape) {
    case "shape":
        typeDataSrc.path_prefix = shape_path_prefix
        typeDataSrc.ch_list = ch_shape_list
        typeDataSrc.en_list = en_shape_list
        break

    case "fruit":
        typeDataSrc.path_prefix = fruit_path_prefix
        typeDataSrc.ch_list = ch_fruit_list
        typeDataSrc.en_list = en_fruit_list
        break

    case "animal":
        typeDataSrc.path_prefix = animal_path_prefix
        typeDataSrc.ch_list = ch_animal_list
        typeDataSrc.en_list = en_animal_list
        break
    }
    return typeDataSrc
}
