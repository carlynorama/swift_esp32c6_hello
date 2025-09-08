@_cdecl("app_main")
func main() {


  guard var led = DigitalIndicator(15) else {
    fatalError("Difficulty setting up pin.")
  }

  guard let button = MomentaryInput(9) else {
    fatalError("Difficulty setting up button.")
  }

  //Waiting for USB...
  delay(2000);


  print("Hello from Swift on ESP32-C6!")
  print(wifi_bridge_return_twelve())

  let wifi = WiFiStation()
  wifi.connect(ssid: "somenetwork", password: "somepassword")

    //Waiting for wifi to connect...
  delay(2000);

  while true {
    if button.isActive {
      led.blink(millis: 500)
    } else {
      led.blink(millis: 2000)
    }
  }
}
