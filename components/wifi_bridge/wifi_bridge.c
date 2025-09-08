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

esp_err_t wifi_bridge_wifi_set_config_and_connect(const char *wifi_ssid, const char *wifi_pass) {
    //uint8_t ssid[32]
    //uint8_t password[64]

    wifi_config_t wifi_config = {0}; // empty config
    //count is the maximum, the the absolute. 
    strncpy((char *)wifi_config.sta.ssid, wifi_ssid, sizeof(wifi_config.sta.ssid));
    strncpy((char *)wifi_config.sta.password, wifi_pass, sizeof(wifi_config.sta.password));

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

    if (ret == ESP_OK) {
        ret = esp_wifi_connect();
    } else {
        return ret;
    }

    return ret;
}
