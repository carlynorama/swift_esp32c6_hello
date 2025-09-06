
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
}


//esp32C6 init
extension OutputPin {
    init(pinNumber:UInt32, activeLow:Bool = true, useInternalHardware:Bool = true) {
        //validate is GPIO output pin.
        let ledPin = gpio_num_t(Int32(pinNumber))
        self.pinNumber = pinNumber

        //validate pin has hardware 
        if activeLow && useInternalHardware {
            //use gpio_pull_mode_t
            gpio_set_pull_mode(ledPin, GPIO_PULLUP_ONLY)
        } else if !activeLow && useInternalHardware {
            gpio_set_pull_mode(ledPin, GPIO_PULLDOWN_ONLY)
        } else {
            //could set with GPIO_FLOATING, but for now want to leave it as default
        }
        guard gpio_reset_pin(ledPin) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }
        guard gpio_set_direction(ledPin, self.direction.esp32C6) == ESP_OK else {
            fatalError("cannot reset output pin \(pinNumber)")
        }
    }
}

// //MARK: InputPin
// struct InputPin:GPIOPin {
//     let pinNumber:UInt32
//     let direction = .input

//     func readLevel(levelHigh:Bool) -> Bool {
//         gpio_get_level(gpio_num_t(Int32(pinNumber)))
//     }
// }
