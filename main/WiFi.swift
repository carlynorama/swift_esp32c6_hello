
final class WiFiStation {
    // var currentSSID:String? 
    // var currentPassword:String?

init() {
        checkWithFatal(wifi_bridge_initialize_nvs())
        checkWithFatal(wifi_bridge_initialize_netif())
        checkWithFatal(wifi_bridge_wifi_init_default_config())
}

// func connect(ssid:String, password:String) {
//     currentSSID = ssid
//     currentPassword = password

//     //checkWithFatal(wifi_bridge_wifi_set_start_config(ssid.utf8CString, password.utf8CString))
//     checkWithFatal(wifi_bridge_wifi_set_start_config())
// }

func connect() {
    // currentSSID = ssid
    // currentPassword = password
    //https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-reference/network/esp_wifi.html#_CPPv417wifi_sta_config_t
    
    //checkWithFatal(wifi_bridge_wifi_set_start_config(ssid.utf8CString, password.utf8CString))
    checkWithFatal(wifi_bridge_wifi_set_start_config())
}



//     func scan(maxCount:UInt16 = 10)  {
//         esp_wifi_scan_start(NULL, true);
//     }
// }

// struct AccessPointInfo {
//     let SSID:String 
//     let RSSI:UInt8
//     let authMode:AuthMode
// }

// // extension AccessPointInfo {

// //     init(espAPInfo:wifi_ap_record_t) {
// //         self.SSID = espAPInfo.SSID
// //         self.RSSI = espAPInfo.RSSI
// //     }
// // }

// enum AuthMode {
//     case open
//     case WEP
//     case WPA_PSK
//     case WPA2_PSK
//     case WPA_WPA2_PSK
//     case enterprise
//     case owe
//     case WPA3_PSK
//     case WPA2_WPA3_PSK
//     case enterprise_WPA3
//     case enterprise_WPA2_WPA3
//     case WPA3_ENT_SUITE_B_192_BIT
//     case unimplemented(CUnsignedInt)
// } 

// extension AuthMode {
//     init(_ mode:wifi_auth_mode_t) {
//         switch (mode) {
//             case WIFI_AUTH_OPEN:
//                 self = .open
//             case WIFI_AUTH_OWE:
//                 self = .owe
//             case WIFI_AUTH_WEP:
//                 self = .WEP
//             case WIFI_AUTH_WPA_PSK:
//                 self = .WPA_PSK
//             case WIFI_AUTH_WPA2_PSK:
//                 self = .WPA2_PSK
//             case WIFI_AUTH_WPA_WPA2_PSK:
//                 self = .WPA_WPA2_PSK
//             case WIFI_AUTH_ENTERPRISE:
//                 self = .enterprise
//             case WIFI_AUTH_WPA3_PSK:
//                 self = .WPA3_PSK
//             case WIFI_AUTH_WPA2_WPA3_PSK:
//                 self = .WPA2_WPA3_PSK
//             case WIFI_AUTH_WPA3_ENTERPRISE:
//                 self = .enterprise_WPA3
//             case WIFI_AUTH_WPA2_WPA3_ENTERPRISE:
//                 self = .enterprise_WPA2_WPA3
//             case WIFI_AUTH_WPA3_ENT_192:
//                 self = .WPA3_ENT_SUITE_B_192_BIT
//             default:
//             self = .unimplemented(mode)
//         }
//     }
}
