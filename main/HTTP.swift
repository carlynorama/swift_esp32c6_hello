

final class HTTPClient {

    func getAndPrint(from host:String, route:String) {
        print("Getting...")
        print(http_bridge_bridge_return_twelve())
        var local_host = host.utf8CString
        var local_route = route.utf8CString
        let resultCode =  http_bridge_get(&local_host, &local_route)
        print("result code: \(resultCode)")
    }
}