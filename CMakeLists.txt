cmake_minimum_required(VERSION 3.10)
project(CryptingTool VERSION 1.0.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include directories
include_directories(include)

# Source files
set(SOURCES
    src/crypting.cpp
    src/crypto_bridge.cpp
)

# Create shared library
add_library(crypting SHARED ${SOURCES})

# Create static library (for platforms that need it)
add_library(crypting_static STATIC ${SOURCES})

# Enhanced Crypto++ library detection with multiple fallback methods
find_package(PkgConfig QUIET)

# Method 1: Try pkg-config first (most reliable)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(CRYPTOPP QUIET cryptopp libcrypto++)
    if(CRYPTOPP_FOUND)
        message(STATUS "Found Crypto++ via pkg-config: ${CRYPTOPP_LIBRARIES}")
        target_link_libraries(crypting ${CRYPTOPP_LIBRARIES})
        target_link_libraries(crypting_static ${CRYPTOPP_LIBRARIES})
        target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
        target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Method 2: Try find_library with multiple possible names
if(NOT CRYPTOPP_LIB_FOUND)
    find_library(CRYPTOPP_LIB 
        NAMES cryptopp crypto++ libcrypto++ cryptopp-static
        PATHS 
            /usr/lib 
            /usr/local/lib 
            /opt/homebrew/lib
            /usr/lib/x86_64-linux-gnu
            /usr/lib/aarch64-linux-gnu
            ${CMAKE_INSTALL_PREFIX}/lib
        DOC "Crypto++ library"
    )
    
    if(CRYPTOPP_LIB)
        message(STATUS "Found Crypto++ library: ${CRYPTOPP_LIB}")
        target_link_libraries(crypting ${CRYPTOPP_LIB})
        target_link_libraries(crypting_static ${CRYPTOPP_LIB})
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Method 3: Try to find headers and link directly (for vcpkg or manual installations)
if(NOT CRYPTOPP_LIB_FOUND)
    find_path(CRYPTOPP_INCLUDE_DIR 
        NAMES cryptopp/cryptlib.h crypto++/cryptlib.h
        PATHS 
            /usr/include 
            /usr/local/include 
            /opt/homebrew/include
            ${CMAKE_INSTALL_PREFIX}/include
    )
    
    if(CRYPTOPP_INCLUDE_DIR)
        message(STATUS "Found Crypto++ headers at: ${CRYPTOPP_INCLUDE_DIR}")
        target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIR})
        target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIR})
        
        # Try to find the library in the same root
        get_filename_component(CRYPTOPP_ROOT ${CRYPTOPP_INCLUDE_DIR} DIRECTORY)
        find_library(CRYPTOPP_LIB 
            NAMES cryptopp crypto++ libcrypto++
            PATHS ${CRYPTOPP_ROOT}/lib
            NO_DEFAULT_PATH
        )
        
        if(CRYPTOPP_LIB)
            target_link_libraries(crypting ${CRYPTOPP_LIB})
            target_link_libraries(crypting_static ${CRYPTOPP_LIB})
            set(CRYPTOPP_LIB_FOUND TRUE)
        endif()
    endif()
endif()

# Method 4: Check for vcpkg installation
if(NOT CRYPTOPP_LIB_FOUND AND DEFINED ENV{VCPKG_ROOT})
    find_package(cryptopp CONFIG QUIET)
    if(cryptopp_FOUND)
        message(STATUS "Found Crypto++ via vcpkg")
        target_link_libraries(crypting cryptopp::cryptopp)
        target_link_libraries(crypting_static cryptopp::cryptopp)
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Final check - if still not found, provide helpful error message
if(NOT CRYPTOPP_LIB_FOUND)
    message(FATAL_ERROR 
        "Crypto++ library not found. Please install it using one of these methods:\n"
        "  Ubuntu/Debian: sudo apt-get install libcrypto++-dev\n"
        "  CentOS/RHEL: sudo yum install cryptopp-devel\n"
        "  macOS: brew install cryptopp\n"
        "  Windows: vcpkg install cryptopp\n"
        "  Or build from source: https://github.com/weidai11/cryptopp"
    )
endif()

# Set output directory
set_target_properties(crypting PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

set_target_properties(crypting_static PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    OUTPUT_NAME crypting
)

# Install targets
install(TARGETS crypting crypting_static
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY include/
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)