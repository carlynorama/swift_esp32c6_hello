#include <string.h>
#include <sys/socket.h>
#include <netdb.h>      // getaddrinfo()
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_log.h"
#include "nvs_flash.h"




void wifi_bridge_connect_and_listen(void);


int wifi_bridge_return_twelve(void);

esp_err_t wifi_bridge_initialize_nvs(void);

esp_err_t wifi_bridge_initialize_netif(void);

esp_err_t wifi_bridge_wifi_init_default_config(void);

//esp_err_t wifi_bridge_wifi_set_start_config(const char* ssid, const char* pass);

esp_err_t wifi_bridge_wifi_set_config_and_connect(const char *wifi_ssid, const char *wifi_pass);