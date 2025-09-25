@_cdecl("app_main")
func main() {


  guard var led = DigitalIndicator(15) else {
    fatalError("Difficulty setting up pin.")
  }

//new button on pin 2 instead of on the boot pin (9)
  guard var button = MomentaryInput(2) else {
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

  while true {

    button.onActivate { 
      let _ = exampleClient.fetch("/")
    }
    delay(50); //to help out the monitor
  }
}
