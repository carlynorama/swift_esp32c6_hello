//No import b/c  HTTPRevisedTypes isn't a Library.

enum HTTPClientError: Error {
  case hostUnresolved
  case couldNotMakeSocket
  case connectionFailed
  case addressUnresolved
  case noSocketOpen
  case sendFailed
  case unsendableRequest

  var describe: String {
    return switch self {
    case .hostUnresolved: "hostUnresolved"
    case .couldNotMakeSocket: "couldNotMakeSocket"
    case .connectionFailed: "connectionFailed"
    case .addressUnresolved: "addressUnresolved"
    case .noSocketOpen: "noSocketOpen"
    case .sendFailed: "sendFailed"
    case .unsendableRequest: "unsendableRequest"
    }
  }
}

protocol HTTPClient {
  func getAndPrint(from: String, route: String, useHTTPS: Bool)

  //make private after they work.
  func getAddressInfo() throws(HTTPClientError)
}

final class MyClient: HTTPClient {
  internal typealias AddrInfo = addrinfo
  internal typealias SocketAddress = sockaddr
  internal typealias SocketHandle = CInt

  var currentInfo: addrinfo?
  var openSocket: SocketHandle?

  deinit {
    if let openSocket {
      close(openSocket)
    }
  }

  func test() {
    let request = HTTPRequest(
      method: .get, scheme: "https", authority: "www.example.com", path: "/")
    print(request.scheme ?? "no scheme")
  }

  func test2() {
    do {
      print("resolving...")
      try getAddressInfo()
      print("connecting...")
      openSocket = try connectSocket()
      print("writing...")
      try writeRequest(path: "/", host: "example.com")
      print("listening...")
      let response = try getResponse()
      if let message = String(validatingUTF8: response) {
        print(message)
      }
      print("done")
    } catch let myError {
      print("Error info: \(myError.describe)")
      if let openSocket {
        close(openSocket)
      }
    }

  }



  func getAddressInfo() throws(HTTPClientError) {
    currentInfo = nil
    var retry = 6 
    while retry > 0 {
        var result: UnsafeMutablePointer<addrinfo>?
        defer { result?.deallocate() }
        let serviceName = "80"  //.utf8CString doesn't work?
        var hints: AddrInfo = addrinfo()
        hints.ai_socktype = SOCK_STREAM  //vs SOCK_DGRAM
        hints.ai_protocol = AF_INET  //IP version 4, vs 6 or unix
        let error = getaddrinfo("example.com", serviceName, &hints, &result)
        if error == 0 {
            currentInfo = result?.pointee
            retry = 0
            print("got it.")
            return
        } else {
            print("getAddressInfo error: \(error)")
            retry = retry - 1
        }
    }
      currentInfo = nil
      throw HTTPClientError.hostUnresolved

  }

  //https://github.com/apple/swift-nio/blob/6c114e3c62ff84ef325d5071b42171d84b63e8a5/Sources/NIOPosix/Socket.swift#L123
  func connectSocket() throws(HTTPClientError) -> SocketHandle {
    if let currentInfo {
      print("I have AddressInfo")
      let socket: SocketHandle = socket(currentInfo.ai_family, currentInfo.ai_socktype, 0)
      if socket < 0 {
        throw HTTPClientError.couldNotMakeSocket
      }
      print("socketHandle: \(socket)")
        var retry = 6 
        while retry > 0 {
            let connectValue = connect(socket, currentInfo.ai_addr, currentInfo.ai_addrlen)
            if connectValue == 0 {
                retry = 0
                return socket
            } else {
                print("connect returned \(connectValue)")
            }
            delay(500)
            retry = retry - 1
            print("retry connect \(retry)")
        }
        close(socket)
        throw HTTPClientError.connectionFailed
    }
    throw HTTPClientError.addressUnresolved
  }

  func writeRequest(path: String, host: String) throws(HTTPClientError) {
    let userAgent = "esp-idf/5.5"
    let request = "GET \(path) HTTP/1.0\r\nHost: \(host)\r\nUser-Agent: \(userAgent)\r\n"

    guard let openSocket else {
      throw HTTPClientError.noSocketOpen
    }
    let result = request.withContiguousStorageIfAvailable { request_buffer in
      return write(openSocket, request_buffer.baseAddress, request_buffer.count)
    }

    if result != nil && result! < 0 {
      close(openSocket)
      self.openSocket = nil
      throw HTTPClientError.sendFailed
    }

    if result == nil {
      throw HTTPClientError.unsendableRequest
    }
  }

  func getResponse() throws(HTTPClientError) -> [Int8] {
    var message: [Int8] = []
    var buffer: [Int8] = Array(repeating: 0, count: 512)

    guard let openSocket else {
      throw HTTPClientError.noSocketOpen
    }
    let _ = buffer.withContiguousMutableStorageIfAvailable { buffer in
      var r: CInt
      repeat {
        r = read(openSocket, buffer.baseAddress, buffer.count - 1)
        buffer[Int(r)] = 0  // null terminate
        message.append(contentsOf: buffer)
      } while r > 0
    }

    close(openSocket)
    self.openSocket = nil

    return message
  }

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

    // var result: UnsafeMutablePointer<addrinfo>?
    // defer { result?.deallocate() }
    // let serviceName = "80"  //.utf8CString doesn't work?
    // var hints: AddrInfo = addrinfo()
    // hints.ai_socktype = SOCK_STREAM  //vs SOCK_DGRAM
    // hints.ai_protocol = AF_INET  //IP version 4, vs 6 or unix
    // let error = getaddrinfo("todbot.com", serviceName, &hints, &result)
    // print("getAddressInfo: \(error)")
    // //print("\(result)")
    // guard error == 0 else {
    //   currentInfo = nil
    //   throw HTTPClientError.hostUnresolved
    // }
    // currentInfo = result?.pointee

// func printAddrInfo() {

// }

//   func test3() {
//     do {
//       print("resolving...")
//       var result_add: UnsafeMutablePointer<addrinfo>?
//       defer { result_add?.deallocate() }
//       let serviceName = "80"  //.utf8CString doesn't work?
//       var hints: AddrInfo = addrinfo()
//       hints.ai_socktype = SOCK_STREAM  //vs SOCK_DGRAM
//       hints.ai_protocol = AF_INET  //IP version 4, vs 6 or unix
//       let error = getaddrinfo("todbot.com", serviceName, &hints, &result_add)
//       print("getAddressInfo: \(error)")
//       //print("\(result)")
//       guard error == 0 else {
//         //   currentInfo = nil
//         throw HTTPClientError.hostUnresolved
//       }
//       print("connecting...")
//         if let result_add {
//                         let socket: SocketHandle = socket(result_add.pointee.ai_family, result_add.pointee.ai_socktype, 0)
//         if socket < 0 {
//             throw HTTPClientError.couldNotMakeSocket
//         }
//         let ret = connect(socket, result_add.pointee.ai_addr, result_add.pointee.ai_addrlen)
//         delay(500)
//         print(
//             "\(result_add.pointee.ai_addr.pointee.sa_family), \(result_add.pointee.ai_addr.pointee.sa_data), \(result_add.pointee.ai_addr.pointee.sa_len), \(result_add.pointee.ai_addrlen)"
//         )
//         print("return value: \(ret))")
//         if ret != 0 {

//         }

//       }

      
//     } catch let myError as HTTPClientError {
//       print("Error info: \(myError.describe)")
//       if let openSocket {
//         close(openSocket)
//       }
//     } catch {
//       print("some other error.")
//     }

//   }