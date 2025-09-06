struct DigitalIndicator {
    let pin:OutputPin 
    let active: Bool
    var expectedState: Bool

    func set(on:Bool) {
        let level = on ? active : !active
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
        vTaskDelay(millis / (1000 / UInt32(configTICK_RATE_HZ)))
    }

    mutating func blink(onMillis:UInt32, offMillis:UInt32) {
        self.turnOn()
        vTaskDelay(onMillis / (1000 / UInt32(configTICK_RATE_HZ)))
        self.turnOff()
        vTaskDelay(offMillis / (1000 / UInt32(configTICK_RATE_HZ)))
    }
}

extension DigitalIndicator {
    init?(_ pinNum: UInt32, activeLow:Bool = true) {
        self.pin = OutputPin(pinNumber: pinNum, activeLow:activeLow)
        self.active = !activeLow
        self.expectedState = false
    }
    
}