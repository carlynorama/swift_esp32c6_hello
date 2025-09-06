struct DigitalIndicator {
    let pin:OutputPin 
    let activeLevel: GPIOLevel
    var expectedState: Bool

    func set(on:Bool) {
        let level = on ? activeLevel.asBool : !activeLevel.asBool
        pin.setLevel(levelHigh:level)
    }

    mutating func turnOn() {
        self.set(on: true)
        expectedState = true
    }

        mutating func turnOff() {
        self.set(on: false)
        expectedState = false
    }

    mutating func toggle() {
        let level: Bool = expectedState ? false : true
        self.set(on: level)
        expectedState = level
    }

    mutating func blink(millis:UInt32) {
        self.toggle()  // Toggle the boolean value
        delay(millis)
    }

    mutating func blink(onMillis:UInt32, offMillis:UInt32) {
        self.turnOn()
        delay(onMillis)
        self.turnOff()
        delay(offMillis)
    }
}

extension DigitalIndicator {
    init?(_ pinNum: UInt32, activeLow:Bool = true) {
        self.pin = OutputPin(pinNumber: pinNum, activeLow:activeLow)
        self.activeLevel = GPIOLevel(!activeLow)
        self.expectedState = false
    }
}