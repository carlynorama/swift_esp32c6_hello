idf_component_register(SRCS "wifi_bridge.c"
                    PRIV_REQUIRES esp_wifi nvs_flash esp_netif
                    INCLUDE_DIRS "include")
