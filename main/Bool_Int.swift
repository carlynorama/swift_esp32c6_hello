extension Bool {
    init(_ v:UInt32) {
        if v == 0 {
            self = false
        } else if v == 1 {
            self = true
        } else {
            fatalError("Expected 0 or 1, got \(v)")
        }
    }

    init(_ v:Int32) {
        if v == 0 {
            self = false
        } else if v == 1 {
            self = true
        } else {
            fatalError("Expected 0 or 1, got \(v)")
        }
    }

    var asUInt32:UInt32 {
        self ? 1 : 0
    }

}