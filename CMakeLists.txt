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

# Optimized Crypto++ library detection with Android NDK support
# This uses modern CMake practices for minimal configuration time and Android compatibility

# Enable result caching for faster subsequent runs
set(CRYPTOPP_ROOT_CACHE "" CACHE PATH "Path to Crypto++ installation root")

# Android-specific library detection
if(ANDROID)
    message(STATUS "🤖 Android build detected - using Android-specific Crypto++ detection")
    
    # For Android, we expect pre-built libraries in specific locations
    set(ANDROID_CRYPTOPP_ROOT "${CMAKE_SOURCE_DIR}/android-libs/${ANDROID_ABI}")
    
    if(EXISTS "${ANDROID_CRYPTOPP_ROOT}/lib/libcryptopp.so")
        message(STATUS "✅ Found pre-built Crypto++ for ${ANDROID_ABI}: ${ANDROID_CRYPTOPP_ROOT}")
        
        # Create imported target for Crypto++
        add_library(cryptopp SHARED IMPORTED)
        set_target_properties(cryptopp PROPERTIES
            IMPORTED_LOCATION "${ANDROID_CRYPTOPP_ROOT}/lib/libcryptopp.so"
            INTERFACE_INCLUDE_DIRECTORIES "${ANDROID_CRYPTOPP_ROOT}/include"
        )
        
        target_link_libraries(crypting cryptopp)
        target_link_libraries(crypting_static cryptopp)
        set(CRYPTOPP_LIB_FOUND TRUE CACHE BOOL "Crypto++ library found")
    else()
        # Fallback: try to find system Crypto++ (unlikely on Android but possible)
        message(WARNING "⚠️ Pre-built Crypto++ not found for ${ANDROID_ABI}, trying system detection...")
    endif()
endif()

# Method 1: Try modern find_package first (fastest for vcpkg/conan installations)
if(NOT ANDROID AND NOT CRYPTOPP_LIB_FOUND)
    find_package(cryptopp CONFIG QUIET)
    if(cryptopp_FOUND)
        message(STATUS "✅ Found Crypto++ via find_package: ${cryptopp_VERSION}")
        target_link_libraries(crypting cryptopp::cryptopp)
        target_link_libraries(crypting_static cryptopp::cryptopp)
        set(CRYPTOPP_LIB_FOUND TRUE CACHE BOOL "Crypto++ library found")
    endif()
endif()

# Method 2: Try pkg-config (fast and reliable for system installations)
if(NOT CRYPTOPP_LIB_FOUND)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        # Try most common names with single call
        pkg_check_modules(CRYPTOPP QUIET libcrypto++ cryptopp)
        if(CRYPTOPP_FOUND)
            message(STATUS "✅ Found Crypto++ via pkg-config: ${CRYPTOPP_LIBRARIES} v${CRYPTOPP_VERSION}")
            target_link_libraries(crypting ${CRYPTOPP_LIBRARIES})
            target_link_libraries(crypting_static ${CRYPTOPP_LIBRARIES})
            target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
            target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
            set(CRYPTOPP_LIB_FOUND TRUE CACHE BOOL "Crypto++ library found")
        endif()
    endif()
endif()

# Method 3: Fast library search (optimized paths, early termination)
if(NOT CRYPTOPP_LIB_FOUND)
    # Search in most common locations first for fastest detection
    find_library(CRYPTOPP_LIB 
        NAMES cryptopp crypto++  # Most common names only
        PATHS 
            ${CRYPTOPP_ROOT_CACHE}/lib
            /usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}  # Use detected architecture
            /usr/local/lib
            /opt/homebrew/lib  # macOS ARM
        NO_DEFAULT_PATH  # Don't search system paths to speed up
        DOC "Crypto++ library"
    )
    
    # Fallback to system paths only if not found above
    if(NOT CRYPTOPP_LIB)
        find_library(CRYPTOPP_LIB NAMES cryptopp crypto++)
    endif()
    
    if(CRYPTOPP_LIB)
        message(STATUS "✅ Found Crypto++ library: ${CRYPTOPP_LIB}")
        target_link_libraries(crypting ${CRYPTOPP_LIB})
        target_link_libraries(crypting_static ${CRYPTOPP_LIB})
        set(CRYPTOPP_LIB_FOUND TRUE CACHE BOOL "Crypto++ library found")
        
        # Quick header check for the found library
        find_path(CRYPTOPP_INCLUDE_DIR 
            NAMES cryptopp/cryptlib.h crypto++/cryptlib.h
            PATHS 
                ${CRYPTOPP_ROOT_CACHE}/include
                /usr/include /usr/local/include /opt/homebrew/include
            NO_DEFAULT_PATH
        )
        if(CRYPTOPP_INCLUDE_DIR)
            target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIR})
            target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIR})
        endif()
    endif()
endif()

# Optimized error handling - concise but helpful
if(NOT CRYPTOPP_LIB_FOUND)
    message(FATAL_ERROR 
        "❌ Crypto++ library not found!\n"
        "\n"
        "📦 Quick Install:\n"
        "  Ubuntu/Debian:  sudo apt-get install libcrypto++-dev\n"
        "  CentOS/RHEL:    sudo yum install cryptopp-devel\n"
        "  macOS:          brew install cryptopp\n"
        "  Windows:        vcpkg install cryptopp\n"
        "\n"
        "🔧 For detailed help: ./crypto_troubleshoot.sh --fix\n"
        "🔗 More info: https://cryptopp.com/wiki/Linux"
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