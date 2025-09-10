cmake_minimum_required(VERSION 3.18)
project(crypto_native)

set(CMAKE_CXX_STANDARD 17)

# Add the crypto library
add_library(crypto_native SHARED
    crypto.cpp
)

# Set library properties
set_target_properties(crypto_native PROPERTIES
    PUBLIC_HEADER crypto.h
    VERSION 1.0.0
    SOVERSION 1
)

# Platform-specific configurations
if(WIN32)
    set_target_properties(crypto_native PROPERTIES
        WINDOWS_EXPORT_ALL_SYMBOLS ON
    )
endif()

# Install targets
install(TARGETS crypto_native
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    PUBLIC_HEADER DESTINATION include
)