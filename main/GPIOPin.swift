
enum GPIOLevel:Equatable {
    case high
    case low
}

extension GPIOLevel {
    init(_ v:Int32) {
        if v == 0 {
            self = .low
        } else if v == 1 {
            self = .high
        } else {
            fatalError("Expected 0 or 1, got \(v)")
        }
    }

    init(_ v:UInt32) {
        if v == 0 {
            self = .low
        } else if v == 1 {
            self = .high
        } else {
            fatalError("Expected 0 or 1, got \(v)")
        }
    }

    init(_ v:Bool) {
        if v == false {
            self = .low
        } else {
            self = .high
        }
    }

    var asUInt32:UInt32 {
        (self == .high) ? 1 : 0
    }

    var asInt32:Int32 {
        (self == .high) ? 1 : 0
    }

    var asBool:Bool {
        (self == .high) ? true : false
    }

    var inverse:GPIOLevel {
        (self == .high) ? .high : .low
    }
}

enum GPIODirection  {
    case input
    case output
}

//esp32C6 implementation
extension GPIODirection {
    var esp32C6:gpio_mode_t {
        switch(self) {
            case .input: 
                return GPIO_MODE_INPUT
            case .output: 
                return GPIO_MODE_OUTPUT
        }
    }
}

protocol GPIOPin {
    var pinNumber:UInt32 { get }
    var direction: GPIODirection { get }
}



//MARK: OutputPin
struct OutputPin:GPIOPin {
    let pinNumber:UInt32
    let direction:GPIODirection = .output

    func setLevel(levelHigh:Bool) {
        gpio_set_level(gpio_num_t(Int32(pinNumber)), levelHigh.asUInt32)
    }

    func setLevel(level:GPIOLevel) {
        gpio_set_level(gpio_num_t(Int32(pinNumber)), level.asUInt32)
    }
}


//esp32C6 init
extension OutputPin {
    init(pinNumber:UInt32, activeLow:Bool = true) {
        //validate is GPIO output pin.
        let ledPin = gpio_num_t(Int32(pinNumber))
        self.pinNumber = pinNumber

        guard gpio_reset_pin(ledPin) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }
        guard gpio_set_direction(ledPin, self.direction.esp32C6) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }
    }
}

// //MARK: InputPin
struct InputPin:GPIOPin {
    let pinNumber:UInt32
    let direction:GPIODirection = .input

    //If the pad is not configured for input (or input and output) the returned value is always 0.
    func readLevel() -> GPIOLevel {
        GPIOLevel(gpio_get_level(gpio_num_t(Int32(pinNumber))))
    }
}

extension InputPin {
    init(pinNumber:UInt32, activeLow:Bool = true, useInternalHardware:Bool = true) {
        //validate is GPIO output pin.
        let ledPin = gpio_num_t(Int32(pinNumber))
        self.pinNumber = pinNumber

        guard gpio_reset_pin(ledPin) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }

        guard gpio_set_direction(ledPin, self.direction.esp32C6) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }

        //validate pin has hardware 
        if activeLow && useInternalHardware {
            //use gpio_pull_mode_t
            gpio_set_pull_mode(ledPin, GPIO_PULLUP_ONLY)
        } else if !activeLow && useInternalHardware {
            gpio_set_pull_mode(ledPin, GPIO_PULLDOWN_ONLY)
        } else {
            //could set with GPIO_FLOATING, but for now want to leave it as default
        }
    }
}
