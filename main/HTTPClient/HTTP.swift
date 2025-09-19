//No import b/c  HTTPRevisedTypes isn't a Library.



enum HTTPClientError:Error {
    case hostUnresolved
}

protocol HTTPClient {
  func getAndPrint(from: String, route: String, useHTTPS: Bool)
  func getAddressInfo() throws(HTTPClientError)
}

final class MyClient: HTTPClient {
    internal typealias AddrInfo = addrinfo
    internal typealias SocketAddress = sockaddr

  func test() {
    let request = HTTPRequest(
      method: .get, scheme: "https", authority: "www.example.com", path: "/")
    print(request.scheme ?? "no scheme")
  }


  

func getAddressInfo() throws(HTTPClientError) {
    var result: UnsafeMutablePointer<addrinfo>?
    defer { result?.deallocate() }
    let serviceName = "80"  //.utf8CString doesn't work? 
    var hints:AddrInfo = addrinfo() 
    hints.ai_socktype = SOCK_STREAM //vs SOCK_DGRAM
    hints.ai_protocol = AF_INET //IP version 4, vs 6 or unix
    let error = getaddrinfo("www.example.com", serviceName, &hints, &result);
    print(error)
    //print("\(result)")
    guard error == 0 else {
        throw HTTPClientError.hostUnresolved
    }
        //     guard getaddrinfo(host, String(port), &hint, &info) == 0 else {
        //     self.fail(SocketAddressError.unknown(host: host, port: port))
        //     return
        // }
  }
//         printf("A");
//     struct addrinfo hints = {
//         .ai_family = AF_INET,
//         .ai_socktype = SOCK_STREAM,
//     };
//     struct addrinfo *res;
//     int s;

//     printf("B");
//     char port_str[] = "80";
//     int err = getaddrinfo(host, port_str, &hints, &res);
//     //int err = getaddrinfo(host, port_str, &hints, &res);
//     if (err != 0 || res == NULL) {
//         printf("DNS lookup failed for %s", host);
//         return 1;
//     }

//     printf("C");
//     s = socket(res->ai_family, res->ai_socktype, 0);
//     if (s < 0) {
//         printf("socket failed");
//         freeaddrinfo(res);
//         return 2;
//     }
//   }

//   func hostIP(_ hostname: String) -> [String] {
//     var ipList: [String] = []

//     guard let host = hostname.withCString({ gethostbyname($0) }) else {
//       return ipList
//     }

//     guard host.pointee.h_length > 0 else {
//       return ipList
//     }

//     var index = 0

//     while host.pointee.h_addr_list[index] != nil {
//       var addr: in_addr = in_addr()
//       memcpy(&addr.s_addr, host.pointee.h_addr_list[index], Int(host.pointee.h_length))
//       guard let remoteIPAsC = inet_ntoa(addr) else {
//         return ipList
//       }

//       ipList.append(String.init(cString: remoteIPAsC))
//       index += 1
//     }

//     return ipList
//   }

//   /// Returns the string representation of the supplied address.
//   ///
//   /// - parameter address: Contains a `(struct sockaddr)` with the address to render.
//   ///
//   /// - returns: A string representation of that address.
//   func stringRepresentation(forAddress address: [UInt8]) -> String? {
//     address.withUnsafeBytes { pointer in
//       var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))

//       let result = getnameinfo(
//         pointer.baseAddress?.assumingMemoryBound(to: sockaddr.self),
//         socklen_t(address.count),
//         &hostStr,
//         socklen_t(hostStr.count),
//         nil,
//         0,
//         NI_NUMERICHOST
//       )
//       guard result == 0 else { return nil }
//       return String(cString: hostStr)
//     }
//   }

  func getAndPrint(from host: String, route: String, useHTTPS: Bool = true) {
    //prepare request
    let _ = HTTPRequest(method: .get, scheme: "https", authority: host, path: "/")

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
