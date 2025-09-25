struct MomentaryInput {

    let pin:InputPin
    let activeLevel: GPIOLevel

    var isActive:Bool {
        pin.readLevel() == activeLevel
    }

    var lastState:GPIOLevel

    typealias OnActiveBehavior = () -> Void
    mutating func onActivate(do behavior:OnActiveBehavior) {
        let currentLevel = pin.readLevel()
        if currentLevel != lastState && currentLevel == activeLevel {
            behavior()
        }
        lastState = currentLevel
    }
}

extension MomentaryInput {
    init?(_ pinNum: UInt32, activeLow:Bool = true, useInternalHardware:Bool = true) {
        self.pin = InputPin(pinNumber: pinNum, activeLow:activeLow, useInternalHardware: useInternalHardware)
        self.activeLevel = GPIOLevel(!activeLow)
        self.lastState = self.activeLevel.inverse
    }
}