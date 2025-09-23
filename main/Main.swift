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
  wifi.connect(ssid: "somessid", password: "somepassword")
  

    //Waiting for wifi to connect...
  delay(2000);
  let exampleClient: some HTTPClient = MyClient(host: "example.com")
  // client.getAndPrint(from: "01k5kwbw3wdhv295vefspdppya00-a23e5bd36f8272130820.requestinspector.com", route: "/")
  // client.test()
  // let _ = try? client.test2()

  // delay(5000);
  // let _ = try? client.test2()

    

  

  while true {
    //let _ = client.test2(host: "192.168.42.124", path: "/", port: 8080)
    let _ = exampleClient.fetch("/")
    if button.isActive {
      led.blink(millis: 500)
    } else {
      led.blink(millis: 2000)
    }
    delay(3000);
  }
}
