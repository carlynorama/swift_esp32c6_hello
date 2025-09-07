#include <stdio.h>
#include "wifi_bridge.h"
#include "esp_wifi.h"


int wifi_bridge_return_twelve(void)
{
    return 12;
}

esp_err_t wifi_bridge_init_default(void) {
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    return esp_wifi_init(&cfg);
}

