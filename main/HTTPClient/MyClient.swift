//No import b/c  HTTPRevisedTypes isn't a Library.

struct  ServerInfo {
    //scheme is always http
    //let useHTTPS: Bool = true
    let host:String //TODO: will have to split to domain for dns lookup?
    let port:Int
    //let basePath = String //future
}


final class MyClient: HTTPClient {
  internal typealias AddrInfo = addrinfo
  internal typealias SocketAddress = sockaddr
  internal typealias SocketHandle = CInt  //none of the functions use socklen_t?

  var defaultServer: ServerInfo
  let userAgent = "esp-idf/5.5"

  init(host: String, port: Int? = nil) {
    if port == nil {
      self.defaultServer = ServerInfo(host: host, port: 80)
    } else {
      self.defaultServer = ServerInfo(host: host, port: port!)
    }
  }

  //var currentInfo: addrinfo?
  var currentInfo: UnsafeMutablePointer<addrinfo>?
  var openSocket: SocketHandle?

  deinit {
    if let openSocket {
      close(openSocket)
    }
    //Is this needed? freeaddrinfo instead?
    if let currentInfo {
      freeaddrinfo(currentInfo)
    }
  }

  // func test() {
  //   let request = HTTPRequest(
  //     method: .get, scheme: "https", authority: "www.example.com", path: "/")
  //   print(request.scheme ?? "no scheme")
  // }

  public func fetch(_ path: String) {
    fetch(path, from:defaultServer)
  }

  public func fetch(_ path: String, from server:ServerInfo) {
    do {
      print("resolving...")
      try getAddressInfo(for: server.host, using: server.port)
      print("connecting...")
      openSocket = try connectSocket()
      freeaddrinfo(currentInfo) //addrinfo has a freshness value.
      assert(currentInfo == nil)
      print("writing...")
      try writeRequest(with: openSocket!, to: defaultServer.host, at: path)
      //wrappedWrite(with: openSocket!, to: host, at: path)
      //TODO - close socket if error throw .sendFailed, .unsendableRequest
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
        currentInfo = nil  //does this free?
      }
    }
  }

  private func getAddressInfo(for host: String, using port: Int = 80) throws(HTTPClientError) {
    currentInfo = nil
    var retry = 6
    let local_host = host.utf8CString
    while retry > 0 {

      // let port = 80  //port or service. port avoids string problem?
      //                     //not 100% sure that passing "\(port)" works.
      //                     //so until can test it, hard code.
      var hints: AddrInfo = addrinfo()
      hints.ai_socktype = SOCK_STREAM  //vs SOCK_DGRAM
      hints.ai_protocol = AF_INET  //IP version 4, vs 6 or unix
      let error = local_host.withContiguousStorageIfAvailable { host_name in
        return getaddrinfo(host_name.baseAddress, "\(port)", &hints, &currentInfo)
      }
      if error == 0 {
        // currentInfo = result?.pointee
        print("got it.")
        retry = 0
        return
      } else {
        if error == nil {
          print("why wasn't contiguous storage available?")
        } else {
          print("getAddressInfo error: \(error!)")
        }
        retry = retry - 1
      }
    }
    currentInfo = nil
    throw HTTPClientError.hostUnresolved

  }

  //https://github.com/apple/swift-nio/blob/6c114e3c62ff84ef325d5071b42171d84b63e8a5/Sources/NIOPosix/Socket.swift#L123
  private func connectSocket() throws(HTTPClientError) -> SocketHandle {
    if let currentInfo {
      print("I have AddressInfo")
      let socket: SocketHandle = socket(
        currentInfo.pointee.ai_family, currentInfo.pointee.ai_socktype, 0)
      if socket < 0 {
        throw HTTPClientError.couldNotMakeSocket
      }
      print("socketHandle: \(socket)")
      var retry = 6
      while retry > 0 {
        let connectValue = connect(
          socket, currentInfo.pointee.ai_addr, currentInfo.pointee.ai_addrlen)
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

  private func writeRequest(with socket: SocketHandle, to host: String, at path: String)
    throws(HTTPClientError)
  {
    //DON'T FORGET THE CLOSING \r\n
    let request: ContiguousArray<CChar> =
      "GET \(path) HTTP/1.0\r\nHost: \(host)\r\nUser-Agent: \(userAgent)\r\n\r\n".utf8CString
    print("request length: \(request.count)")
    print("\(request)")

    let result = request.withContiguousStorageIfAvailable { request_buffer in
      let writeResponse = write(socket, request_buffer.baseAddress, request_buffer.count)
      print("writeResponse: \(writeResponse)")
      return writeResponse
    }

    if result != nil && result! < 0 {
      close(socket)
      self.openSocket = nil
      throw HTTPClientError.sendFailed
    }

    if result == nil {
      print("what happened?")
      throw HTTPClientError.unsendableRequest
    }
  }

  private func getResponse() throws(HTTPClientError) -> [Int8] {
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

  private func wrappedWrite(with socket: SocketHandle, to host: String, at path: String) {
    let local_host = host.utf8CString
    let local_path = path.utf8CString
    //TODO: test with span/inline array (esp-idf 6? OS26)
    local_path.withContiguousStorageIfAvailable { route_buffer in
      local_host.withContiguousStorageIfAvailable { host_buffer in
        let resultCode = http_bridge_just_write(
          socket, host_buffer.baseAddress, route_buffer.baseAddress)
        print("write result code: \(resultCode)")
      }
    }
  }

  //original:
  // func getAndPrint(from host: String, route: String, useHTTPS: Bool = true) {
  //   //prepare request
  //   let _ = HTTPRequest(method: .get, scheme: "https", authority: host, path: "/")

  //   let local_host = host.utf8CString
  //   let local_route = route.utf8CString

  //   //TODO: test with span on beta?
  //   local_route.withContiguousStorageIfAvailable { route_buffer in
  //     local_host.withContiguousStorageIfAvailable { host_buffer in
  //       let resultCode = http_bridge_get(host_buffer.baseAddress, route_buffer.baseAddress)
  //       print("result code: \(resultCode)")
  //     }
  //   }
  //}

}
