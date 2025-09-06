
typealias SDKError = esp_err_t

func checkWithFatal(_ error:SDKError, message:String = "") {
    guard error == ESP_OK else {
        fatalError(message)
    }
}

func checkWithThrow(_ error:SDKError, throws swiftError: some Error) throws {
    guard error == ESP_OK else {
        throw(swiftError)
    }
}