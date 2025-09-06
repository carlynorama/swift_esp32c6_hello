
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
// struct InputPin:GPIOPin {
//     let pinNumber:UInt32
//     let direction = .input

//     func readLevel(levelHigh:Bool) -> Bool {
//         gpio_get_level(gpio_num_t(Int32(pinNumber)))
//     }
// }
