
#include "http_bridge.h"

int http_bridge_bridge_return_twelve(void)
{
    return 12;
}

int http_bridge_get(const char *host, const char *path) {
    struct addrinfo hints = {
        .ai_family = AF_INET,
        .ai_socktype = SOCK_STREAM,
    };
    struct addrinfo *res;
    int s;

    printf("B");
    char port_str[] = "80";
    int err = getaddrinfo(host, port_str, &hints, &res);
    //int err = getaddrinfo(host, port_str, &hints, &res);
    if (err != 0 || res == NULL) {
        printf("DNS lookup failed for %s", host);
        return 1;
    }

    printf("C");
    s = socket(res->ai_family, res->ai_socktype, 0);
    if (s < 0) {
        printf("socket failed");
        freeaddrinfo(res);
        return 2;
    }

    printf("D");
    if (connect(s, res->ai_addr, res->ai_addrlen) != 0) {
        printf("connect failed");
        close(s);
        freeaddrinfo(res);
        return 3;
    }

    printf("E");
    freeaddrinfo(res);
    
    printf("F");
    char req[128];
    snprintf(req, sizeof(req),
             "GET %s HTTP/1.0\r\n"
             "Host: %s\r\n"
             "User-Agent: esp-idf/5.5\r\n"
             "\r\n",
             path, host);

    if (write(s, req, strlen(req)) < 0) {
        printf("send failed");
        close(s);
        return 4;
    }

    char recv_buf[512];
    int r;
    while ((r = read(s, recv_buf, sizeof(recv_buf) - 1)) > 0) {
        recv_buf[r] = 0; // null terminate
        printf("%s", recv_buf);
    }
    close(s);
    return 100;
}
