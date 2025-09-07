
typealias SDKError = esp_err_t

func checkWithFatal(_ error:SDKError, message:String) {
    guard error == ESP_OK else {
        fatalError(message)
    }
}

func checkWithFatal(_ error:SDKError) {
    guard error == ESP_OK else {
        fatalError(String(cString:esp_err_to_name(error)))
    }
}

func checkWithThrow(_ error:SDKError, throws swiftError: some Error) throws {
    guard error == ESP_OK else {
        throw(swiftError)
    }
}

func checkWithThrow(_ error:SDKError) throws {
    guard error == ESP_OK else {
        throw(SDKErrorWrapper.passMessage(String(cString:esp_err_to_name(error))))
    }
}

enum SDKErrorWrapper:Error {
    case passMessage(String)
}