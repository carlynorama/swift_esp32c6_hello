## Removed 

- conformances to Codable
- conformances to CustomPlaygroundDisplayConvertible
- all .description (only reaming one in CustomDebugStringConvertible)
- No MUTEX, No NIO Lock
- no keypaths
- no 'any Error'

Likely caused by dictionary with string as key? No, there is more...
https://github.com/swiftlang/swift/issues/75678
https://forums.swift.org/t/what-is-swift-stdlib-getnormdata/73989/3
https://docs.swift.org/embedded/documentation/embedded/strings
undefined reference to `_swift_stdlib_getNormData'
undefined reference to `_swift_stdlib_getComposition'
undefined reference to `_swift_stdlib_getDecompositionEntry'
undefined reference to `_swift_stdlib_nfd_decompositions'

ld ... -o binary output.o $(dirname `which swiftc`)/../lib/swift/embedded/armv6m-none-none-eabi/libswiftUnicodeDataTables.a

- doesn't work with swiftly
- get the one for my target architecture

cp /System/Volumes/Data/Users/$USER/Library/Developer/Toolchains/swift-6.2-RELEASE.xctoolchain/usr/lib/swift/embedded/riscv32-none-none-eabi/libswiftUnicodeDataTables.a libswiftUnicodeDataTables.a


TODO: Try the more recent espressif tools? 



## MISC ERRORS

- error: cannot find 'Mutex' in scope

- /HTTPFields.swift:182:51: error: cannot convert value of type 'String' to expected argument type 'String.Element' (aka 'Character')


Swift.Array.description:2:12: note: 'description' has been explicitly marked unavailable here
1 | generic struct Array {
2 | public var description: ISOLatin1String { get }}
  |            `- note: 'description' has been explicitly marked unavailable here

194 | extension LockStorage: @unchecked Sendable {}
    |                                   `- warning: conformance of 'LockStorage<Value>' to protocol 'Sendable' is already unavailable

142 | // See also: https://github.com/apple/swift/pull/40000
143 | final class LockStorage<Value>: ManagedBuffer<Value, LockPrimitive> {
    |             `- note: 'LockStorage<Value>' inherits conformance to protocol 'Sendable' from superclass here
144 | 
145 |     static func create(value: Value) -> Self {    q


/HTTPRevisedTypes/HTTPFields.swift:35:14: error: classes cannot have non-final generic functions in embedded Swift
 33 |         }
 34 | 
 35 |         func withLock<Result>(_ body: () throws -> Result) rethrows -> Result {
    |              `- error: classes cannot have non-final generic functions in embedded Swift
 36 |             fatalError()
 37 |         }

/HTTPRevisedTypes/HTTPFields.swift:178:40: error: cannot use key path in embedded Swift
176 |             if fields.first(where: { _ in true }) != nil {
177 |                 let separator = name == .cookie ? "; " : ", "
178 |                 return fields.lazy.map(\.value).joined(separator: separator)
    |                                        `- error: cannot use key path in embedded Swift
179 |             } else {
180 |                 return nil

/HTTPRevisedTypes/HTTPParsedFields.swift:49:36: error: cannot use a value of protocol type 'any Error' in embedded Swift
 47 |         if field.name.isPseudo {
 48 |             if !self.fields.isEmpty {
 49 |                 throw ParsingError.pseudoNotFirst
    |                                    `- error: cannot use a value of protocol type 'any Error' in embedded Swift
 50 |             }
 51 |             switch field.name {


/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es30_stringCompareFastUTF8Abnormal33_835F230159459CFFE280B5F8E69D8077LL__9expectingSbSRys5UInt8VG_AFs23_StringComparisonResultOtF':
Main.swift.obj:(.text.$es30_stringCompareFastUTF8Abnormal33_835F230159459CFFE280B5F8E69D8077LL__9expectingSbSRys5UInt8VG_AFs23_StringComparisonResultOtF+0x8a): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: Main.swift.obj:(.text.$es30_stringCompareFastUTF8Abnormal33_835F230159459CFFE280B5F8E69D8077LL__9expectingSbSRys5UInt8VG_AFs23_StringComparisonResultOtF+0x9c): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$eSRss5UInt8VRszlE24hasNormalizationBoundary6beforeSbSi_tF':
Main.swift.obj:(.text.$eSRss5UInt8VRszlE24hasNormalizationBoundary6beforeSbSi_tF+0x3c): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es13_findBoundary33_835F230159459CFFE280B5F8E69D8077LL_6beforeSiSRys5UInt8VG_SitF':
Main.swift.obj:(.text.$es13_findBoundary33_835F230159459CFFE280B5F8E69D8077LL_6beforeSiSRys5UInt8VG_SitF+0x44): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b21V6resume9consumingAB6f25VSgAIyXE_tFAH6scalar_AB9_hI20V04normH0tSgADzXEfU_AIIgd_Tf1cn_n':
Main.swift.obj:(.text.$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b21V6resume9consumingAB6f25VSgAIyXE_tFAH6scalar_AB9_hI20V04normH0tSgADzXEfU_AIIgd_Tf1cn_n+0xf0): undefined reference to `_swift_stdlib_getComposition'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: Main.swift.obj:(.text.$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b21V6resume9consumingAB6f25VSgAIyXE_tFAH6scalar_AB9_hI20V04normH0tSgADzXEfU_AIIgd_Tf1cn_n+0x112): undefined reference to `_swift_stdlib_getComposition'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b10V5flushAB6f19VSgyFAG6scalar_AB9_hI20V04normG0tSgADzXEfU_Tf1cn_n':
Main.swift.obj:(.text.$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b10V5flushAB6f19VSgyFAG6scalar_AB9_hI20V04normG0tSgADzXEfU_Tf1cn_n+0x216): undefined reference to `_swift_stdlib_getComposition'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: Main.swift.obj:(.text.$es7UnicodeO14_NFCNormalizerV7_resume12consumingNFDAB6ScalarVSgAH6scalar_AB9_NormDataV04normI0tSgADzXE_tF04$es7a4O14_b10V5flushAB6f19VSgyFAG6scalar_AB9_hI20V04normG0tSgADzXEfU_Tf1cn_n+0x236): undefined reference to `_swift_stdlib_getComposition'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es7UnicodeO14_NFDNormalizerV7_resume9consumingAB6ScalarV6scalar_AB9_NormDataV04normH0tSgAHSgyXE_tF':
Main.swift.obj:(.text.$es7UnicodeO14_NFDNormalizerV7_resume9consumingAB6ScalarV6scalar_AB9_NormDataV04normH0tSgAHSgyXE_tF+0x18a): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es7UnicodeO14_NFDNormalizerV13decomposeSlow33_B136021ACF5AAEFA178D70CE67C7EEF0LLyyAB6ScalarV6scalar_AB9_NormDataV04normO0t_tF':
Main.swift.obj:(.text.$es7UnicodeO14_NFDNormalizerV13decomposeSlow33_B136021ACF5AAEFA178D70CE67C7EEF0LLyyAB6ScalarV6scalar_AB9_NormDataV04normO0t_tF+0xa): undefined reference to `_swift_stdlib_getDecompositionEntry'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: Main.swift.obj:(.text.$es7UnicodeO14_NFDNormalizerV13decomposeSlow33_B136021ACF5AAEFA178D70CE67C7EEF0LLyyAB6ScalarV6scalar_AB9_NormDataV04normO0t_tF+0x1c): undefined reference to `_swift_stdlib_nfd_decompositions'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: Main.swift.obj:(.text.$es7UnicodeO14_NFDNormalizerV13decomposeSlow33_B136021ACF5AAEFA178D70CE67C7EEF0LLyyAB6ScalarV6scalar_AB9_NormDataV04normO0t_tF+0xd0): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es14_isScalarNFCQCySbs7UnicodeO0B0V_s5UInt8VztF':
Main.swift.obj:(.text.$es14_isScalarNFCQCySbs7UnicodeO0B0V_s5UInt8VztF+0x40): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: esp-idf/main/libmain.a(Main.swift.obj): in function `$es14_nfcQuickCheck_7prevCCCSbSRys5UInt8VG_ADztF':
Main.swift.obj:(.text.$es14_nfcQuickCheck_7prevCCCSbSRys5UInt8VG_ADztF+0x6e): undefined reference to `_swift_stdlib_getNormData'
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: main.elf: hidden symbol `_swift_stdlib_getNormData' isn't defined
/Users/$USER/.espressif/tools/riscv32-esp-elf/esp-14.2.0_20241119/riscv32-esp-elf/bin/../lib/gcc/riscv32-esp-elf/14.2.0/../../../../riscv32-esp-elf/bin/ld: final link failed: bad value
collect2: error: ld returned 1 exit status
ninja: build stopped: subcommand failed.

