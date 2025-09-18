

## Removed 

- conformances to Codable
- conformances to CustomPlaygroundDisplayConvertible
- all .description (only reaming one in CustomDebugStringConvertible)


- error: cannot find 'Mutex' in scope

- /HTTPFields.swift:182:51: error: cannot convert value of type 'String' to expected argument type 'String.Element' (aka 'Character')


Swift.Array.description:2:12: note: 'description' has been explicitly marked unavailable here
1 | generic struct Array {
2 | public var description: String { get }}
  |            `- note: 'description' has been explicitly marked unavailable here

194 | extension LockStorage: @unchecked Sendable {}
    |                                   `- warning: conformance of 'LockStorage<Value>' to protocol 'Sendable' is already unavailable

142 | // See also: https://github.com/apple/swift/pull/40000
143 | final class LockStorage<Value>: ManagedBuffer<Value, LockPrimitive> {
    |             `- note: 'LockStorage<Value>' inherits conformance to protocol 'Sendable' from superclass here
144 | 
145 |     static func create(value: Value) -> Self {    q