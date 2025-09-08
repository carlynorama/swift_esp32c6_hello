final class WiFiStation {
    // var currentSSID:String?
    // var currentPassword:String?

    init() {
        checkWithFatal(wifi_bridge_initialize_nvs())
        checkWithFatal(wifi_bridge_initialize_netif())
        checkWithFatal(wifi_bridge_wifi_init_default_config())
    }

    func connect(ssid: String, password: String) {
        //     currentSSID = ssid
        //     currentPassword = password
        var local_ssid = ssid.utf8CString
        var local_pass = password.utf8CString

        checkWithFatal(wifi_bridge_wifi_set_config_and_connect(&local_ssid, &local_pass))
    }

}
