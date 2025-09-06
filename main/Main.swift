@_cdecl("app_main")
func main() {
  print("Hello from Swift on ESP32-C6!")
  guard var led = DigitalIndicator(15) else {
    fatalError("Difficulty setting up pin.")
  }
  while true {
    led.blink(onMillis: 500, offMillis: 2000)
  }
}
