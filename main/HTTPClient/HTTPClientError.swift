
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
