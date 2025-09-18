// import HTTPTypes

// import HTTPSimpleTypes

final class HTTPClient {

    func test() {
        //let type = HTTPHello()
        //print(type.helloInt)
    }

    // func test() {
    //     let request = HTTPRequest(method: .get, scheme: "https", authority: "www.example.com", path: "/")
    //     print(request.scheme)
    // }

    func getAndPrint(from host: String, route: String) {
        print("Getting...")
        print(http_bridge_bridge_return_twelve())
        let local_host = host.utf8CString
        let local_route = route.utf8CString

        //TODO: test with span on beta?
        local_route.withContiguousStorageIfAvailable { route_buffer in
            local_host.withContiguousStorageIfAvailable { host_buffer in
                let resultCode = http_bridge_get(host_buffer.baseAddress, route_buffer.baseAddress)
                print("result code: \(resultCode)")
            }
        }

    }
}
