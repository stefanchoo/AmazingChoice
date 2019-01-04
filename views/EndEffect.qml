import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
    id: root
    width: size
    height: width
    property int size: 60
    property string bColor: "white"

    property int value: 0

    z: 150

    EndEffectAction {
        id: circle
        width: size
        secondaryColor: bColor
    }

    states: [
        State {
            name: "moveState"
            PropertyChanges {
                target: circle
                action: "move"
                currentValue: 0
                opacity: 1
            }
        },

        State {
            name: "chooseState"
            PropertyChanges {
                target: circle
                opacity: 1
                action: "choose"
                currentValue: 5
            }
        }
    ]
}
