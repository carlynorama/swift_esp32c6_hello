@_cdecl("app_main")
func main() {
  print("Hello from Swift on ESP32-C6!")

  guard var led = DigitalIndicator(15) else {
    fatalError("Difficulty setting up pin.")
  }

  guard let button = DigitalInput(9) else {
    fatalError("Difficulty setting up button.")
  }

  while true {
    if button.isActive {
      led.blink(millis: 500)
    } else {
      led.blink(millis: 2000)
    }
  }
}
