
struct MomentaryInput {
    let pin:InputPin
    let activeLevel: GPIOLevel

    var isActive:Bool {
        pin.readLevel() == activeLevel
    }
}

extension MomentaryInput {
    init?(_ pinNum: UInt32, activeLow:Bool = true, useInternalHardware:Bool = true) {
        self.pin = InputPin(pinNumber: pinNum, activeLow:activeLow, useInternalHardware: useInternalHardware)
        self.activeLevel = GPIOLevel(!activeLow)
    }
}