# Register the app as an IDF component
idf_component_register(
    SRCS /dev/null # We don't have any C++ sources
    # PRIV_REQUIRES test_cmp
    PRIV_INCLUDE_DIRS "."
)

idf_build_get_property(target IDF_TARGET)
idf_build_get_property(arch IDF_TARGET_ARCH)

if("${arch}" STREQUAL "xtensa")
    message(FATAL_ERROR "Not supported target: ${target}")
endif()

# Extract the -march flag and remove any vendor-specific extensions (_x*)
string(REGEX MATCH "-march=[^ ]+" march_flag "${CMAKE_C_FLAGS}")
string(REGEX REPLACE "_x[^ ]*" "" march_flag "${march_flag}")

# Extract the -mabi flag or set a default value if not present
string(REGEX MATCH "-mabi=[^ ]+" mabi_flag "${CMAKE_C_FLAGS}")
if("${mabi_flag}" STREQUAL "")
    set(mabi_flag "-mabi=ilp32")
endif()

# Clear the default COMPILE_OPTIONS which include a lot of C/C++ specific compiler flags that the Swift compiler will not accept
get_target_property(var ${COMPONENT_LIB} COMPILE_OPTIONS)
set_target_properties(${COMPONENT_LIB} PROPERTIES COMPILE_OPTIONS "")

# Compute -Xcc flags to set up the C and C++ header search paths for Swift (for bridging header).
set(SWIFT_INCLUDES)
foreach(dir ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-Xcc ")
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-I${dir} ")
endforeach()
foreach(dir ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-Xcc ")
    string(CONCAT SWIFT_INCLUDES ${SWIFT_INCLUDES} "-I${dir} ")
endforeach()

# Swift compiler flags to build in Embedded Swift mode, optimize for size, choose the right ISA, ABI, etc.
target_compile_options(${COMPONENT_LIB} PUBLIC "$<$<COMPILE_LANGUAGE:Swift>:SHELL:
        -target riscv32-none-none-eabi
        -Xfrontend -function-sections -enable-experimental-feature Embedded -wmo -parse-as-library -Osize
        -Xcc ${march_flag} -Xcc ${mabi_flag} -Xcc -fno-pic -Xcc -fno-pie
        
        -pch-output-dir /tmp
        -Xfrontend -enable-single-module-llvm-emission
        
        ${SWIFT_INCLUDES}

        -import-bridging-header ${CMAKE_CURRENT_LIST_DIR}/BridgingHeader.h
    >")

# Enable Swift support in CMake, force Whole Module builds (required by Embedded Swift), and use "CMAKE_Swift_COMPILER_WORKS" to
# skip the trial compilations which don't (yet) correctly work when cross-compiling.
set(CMAKE_Swift_COMPILER_WORKS YES)
set(CMAKE_Swift_COMPILATION_MODE_DEFAULT wholemodule)
set(CMAKE_Swift_COMPILATION_MODE wholemodule)
enable_language(Swift)

## For seeing what will fail in from unchanged folder. 
# add_subdirectory(HTTPTypes)
# target_link_libraries(${COMPONENT_LIB} PUBLIC HTTPTypes)
# target_include_directories(${COMPONENT_LIB} PUBLIC HTTPTypes)


# execute_process(COMMAND which swiftc OUTPUT_VARIABLE WHICH_SWIFT)
# execute_process(COMMAND  dirname ${WHICH_SWIFT} OUTPUT_VARIABLE DIR_SWIFT)
# message(" -------------------------- ${DIR_SWIFT} -------------------------")

# Swiftly install doesn't map the toolchain location correctly. 

# Note this is from 6.2 Release
# /System/Volumes/Data/Users/$USER/Library/Developer/Toolchains/swift-6.2-RELEASE.xctoolchain/usr/lib/swift/embedded/
# target_link_libraries(${COMPONENT_LIB} ${CMAKE_SOURCE_DIR}/helpers/riscv32-none-none-eabi/libswiftUnicodeDataTables.a)

# get_filename_component(compiler_bin_dir ${CMAKE_Swift_COMPILER} DIRECTORY)
# target_link_directories(${COMPONENT_LIB} PUBLIC "${compiler_bin_dir}/../lib/swift/embedded/riscv32-none-none-eabi")
# target_link_directories(${COMPONENT_LIB} PUBLIC "${CMAKE_SOURCE_DIR}/helpers/riscv32-none-none-eabi/libswiftUnicodeDataTables.a")
# target_link_libraries(${COMPONENT_LIB} PUBLIC
#     -Wl,--whole-archive
#     swiftUnicodeDataTables
#     -Wl,--no-whole-archive
#     )

target_link_libraries(${COMPONENT_LIB} PUBLIC
    -Wl,--whole-archive
    ${CMAKE_SOURCE_DIR}/helpers/riscv32-none-none-eabi/libswiftUnicodeDataTables.a
    -Wl,--no-whole-archive
    )


# List of Swift source files to build.
target_sources(${COMPONENT_LIB}
    PRIVATE
    Main.swift
    Bool_Int.swift
    GPIOPin.swift
    DigitalIndicator.swift
    MomentaryInput.swift
    Delay.swift     
    ErrorHandler.swift
    WiFi.swift
    HTTP.swift
    HTTPRevisedTypes/HTTPField.swift
    HTTPRevisedTypes/HTTPFieldName.swift
    HTTPRevisedTypes/HTTPFields.swift
    HTTPRevisedTypes/HTTPParsedFields.swift
    HTTPRevisedTypes/HTTPRequest.swift
    HTTPRevisedTypes/HTTPResponse.swift
    HTTPRevisedTypes/ISOLatin1String.swift
    HTTPRevisedTypes/NIOLock.swift
)

add_custom_command(
    TARGET ${COMPONENT_LIB}
    POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} --remove-section .swift_modhash
            $<TARGET_FILE:${COMPONENT_LIB}> $<TARGET_FILE:${COMPONENT_LIB}>
)
