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
        let local_ssid = ssid.utf8CString
        let local_pass = password.utf8CString

        //TODO: test with span on beta?
        local_pass.withContiguousStorageIfAvailable { pass_buffer in
            local_ssid.withContiguousStorageIfAvailable { ssid_buffer in
                checkWithFatal(
                    wifi_bridge_wifi_set_config_and_connect(
                        ssid_buffer.baseAddress, pass_buffer.baseAddress))
            }
        }
        // checkWithFatal(wifi_bridge_wifi_set_config_and_connect(&local_ssid, &local_pass))
    }

}
