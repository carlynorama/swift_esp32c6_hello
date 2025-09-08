

final class HTTPClient {

    func getAndPrint(from host:String, route:String) {
        var local_host = host
        var local_route = route
        http_bridge_get(&local_host, &local_route)
    }
}