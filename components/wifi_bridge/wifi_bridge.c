#include <string.h>
// #include "freertos/FreeRTOS.h"
// #include "freertos/event_groups.h"
#include "esp_wifi.h"
// #include "esp_log.h"
// #include "esp_event.h"
#include "nvs_flash.h"

#include "wifi_bridge.h"


int wifi_bridge_return_twelve(void)
{
    return 12;
}



esp_err_t wifi_bridge_initialize_nvs(void) {
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        esp_err_t flash_ret = nvs_flash_erase();
        if (flash_ret == ESP_OK) {
             ret = nvs_flash_init();
        } else {
            ret = flash_ret;
        }
    }
    return ret;
}

//TODO: what if needed that pointer later? 
esp_err_t wifi_bridge_initialize_netif(void) {
    esp_err_t ret = esp_netif_init();
    if (ret == ESP_OK) {
        ret = esp_event_loop_create_default();
    }
    esp_netif_t *sta_netif = esp_netif_create_default_wifi_sta();
    assert(sta_netif);
    return ret ;
}

esp_err_t wifi_bridge_wifi_init_default_config(void) {
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    return esp_wifi_init(&cfg);
}

#define WIFI_SSID "garbage"
#define WIFI_PASSWORD "garbage"
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_OPEN
#define ESP_WIFI_SAE_MODE WPA3_SAE_PWE_HUNT_AND_PECK
#define EXAMPLE_H2E_IDENTIFIER ""

esp_err_t wifi_bridge_wifi_set_start_config() {
    //uint8_t ssid[32]
    //uint8_t password[64]

    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASSWORD,
            /* Authmode threshold resets to WPA2 as default if password matches WPA2 standards (password len => 8).
             * If you want to connect the device to deprecated WEP/WPA networks, Please set the threshold value
             * to WIFI_AUTH_WEP/WIFI_AUTH_WPA_PSK and set the password with length and format matching to
             * WIFI_AUTH_WEP/WIFI_AUTH_WPA_PSK standards.
             */
            .threshold.authmode = ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD,
            .sae_pwe_h2e = ESP_WIFI_SAE_MODE,
            .sae_h2e_identifier = EXAMPLE_H2E_IDENTIFIER,
        },
    };
    esp_err_t ret = esp_wifi_set_mode(WIFI_MODE_STA);
    if (ret == ESP_OK) {
        ret = esp_wifi_set_config(WIFI_IF_STA, &wifi_config);
    } else {
        return ret;
    }

    if (ret == ESP_OK) {
        ret = esp_wifi_start();
    } else {
        return ret;
    }
    return ret;
}







