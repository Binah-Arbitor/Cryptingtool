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

# Enhanced Crypto++ library detection with optimized fallback methods
# Using the most reliable detection order based on common package distributions
find_package(PkgConfig QUIET)

# Method 1: Try pkg-config first (most reliable for standard installations)
if(PKG_CONFIG_FOUND)
    # Try libcrypto++ first (most common name), then cryptopp as fallback
    pkg_check_modules(CRYPTOPP QUIET libcrypto++)
    if(NOT CRYPTOPP_FOUND)
        pkg_check_modules(CRYPTOPP QUIET cryptopp)
    endif()
    
    if(CRYPTOPP_FOUND)
        message(STATUS "✅ Found Crypto++ via pkg-config: ${CRYPTOPP_LIBRARIES}")
        message(STATUS "   Version: ${CRYPTOPP_VERSION}")
        message(STATUS "   Include dirs: ${CRYPTOPP_INCLUDE_DIRS}")
        target_link_libraries(crypting ${CRYPTOPP_LIBRARIES})
        target_link_libraries(crypting_static ${CRYPTOPP_LIBRARIES})
        target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
        target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIRS})
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Method 2: Try find_library with prioritized names (common library names)
if(NOT CRYPTOPP_LIB_FOUND)
    # Try the most common library names first: cryptopp (most standard), then alternatives
    find_library(CRYPTOPP_LIB 
        NAMES cryptopp crypto++ libcrypto++ cryptopp-static libcryptopp
        PATHS 
            /usr/lib/x86_64-linux-gnu    # Ubuntu/Debian primary path
            /usr/lib/aarch64-linux-gnu   # ARM64 Ubuntu/Debian
            /usr/lib                     # Standard library path
            /usr/local/lib               # Local installations
            /opt/homebrew/lib            # macOS Homebrew (ARM)
            /usr/local/homebrew/lib      # macOS Homebrew (Intel)
            ${CMAKE_INSTALL_PREFIX}/lib  # Custom install prefix
        DOC "Crypto++ library"
    )
    
    if(CRYPTOPP_LIB)
        message(STATUS "✅ Found Crypto++ library: ${CRYPTOPP_LIB}")
        target_link_libraries(crypting ${CRYPTOPP_LIB})
        target_link_libraries(crypting_static ${CRYPTOPP_LIB})
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Method 3: Header-based detection with manual linking (for custom builds)
if(NOT CRYPTOPP_LIB_FOUND)
    find_path(CRYPTOPP_INCLUDE_DIR 
        NAMES cryptopp/cryptlib.h crypto++/cryptlib.h
        PATHS 
            /usr/include 
            /usr/local/include 
            /opt/homebrew/include
            /usr/local/homebrew/include
            ${CMAKE_INSTALL_PREFIX}/include
    )
    
    if(CRYPTOPP_INCLUDE_DIR)
        message(STATUS "✅ Found Crypto++ headers at: ${CRYPTOPP_INCLUDE_DIR}")
        target_include_directories(crypting PRIVATE ${CRYPTOPP_INCLUDE_DIR})
        target_include_directories(crypting_static PRIVATE ${CRYPTOPP_INCLUDE_DIR})
        
        # Try to find the library in the same installation root
        get_filename_component(CRYPTOPP_ROOT ${CRYPTOPP_INCLUDE_DIR} DIRECTORY)
        find_library(CRYPTOPP_LIB 
            NAMES cryptopp crypto++ libcrypto++ libcryptopp
            PATHS ${CRYPTOPP_ROOT}/lib ${CRYPTOPP_ROOT}/lib64
            NO_DEFAULT_PATH
        )
        
        if(CRYPTOPP_LIB)
            message(STATUS "✅ Found matching Crypto++ library: ${CRYPTOPP_LIB}")
            target_link_libraries(crypting ${CRYPTOPP_LIB})
            target_link_libraries(crypting_static ${CRYPTOPP_LIB})
            set(CRYPTOPP_LIB_FOUND TRUE)
        else()
            message(STATUS "⚠️  Found headers but no matching library, will try manual linking")
            # Try common library names in standard paths as last resort
            find_library(CRYPTOPP_LIB 
                NAMES cryptopp crypto++ libcrypto++
                PATHS /usr/lib /usr/local/lib /usr/lib/x86_64-linux-gnu
            )
            if(CRYPTOPP_LIB)
                message(STATUS "✅ Found Crypto++ library via fallback: ${CRYPTOPP_LIB}")
                target_link_libraries(crypting ${CRYPTOPP_LIB})
                target_link_libraries(crypting_static ${CRYPTOPP_LIB})
                set(CRYPTOPP_LIB_FOUND TRUE)
            endif()
            message(STATUS "⚠️  Found headers but no matching library, trying system library")
            # Try linking with standard name
            target_link_libraries(crypting cryptopp)
            target_link_libraries(crypting_static cryptopp)
            set(CRYPTOPP_LIB_FOUND TRUE)
        endif()
    endif()
endif()

# Method 4: Check for vcpkg installation (Windows/cross-platform package manager)
if(NOT CRYPTOPP_LIB_FOUND AND DEFINED ENV{VCPKG_ROOT})
    find_package(cryptopp CONFIG QUIET)
    if(cryptopp_FOUND)
        message(STATUS "✅ Found Crypto++ via vcpkg")
        target_link_libraries(crypting cryptopp::cryptopp)
        target_link_libraries(crypting_static cryptopp::cryptopp)
        set(CRYPTOPP_LIB_FOUND TRUE)
    endif()
endif()

# Final check - if still not found, provide comprehensive error message with instructions
if(NOT CRYPTOPP_LIB_FOUND)
    message(FATAL_ERROR 
"Crypto++ library not found. Please install it using one of these methods:\n"
        "❌ Crypto++ library not found!\n"
        "\n"
        "Please install Crypto++ using one of these methods:\n"
        "\n"
        "📦 PACKAGE MANAGERS:\n"
        "  Ubuntu/Debian:  sudo apt-get install libcrypto++-dev\n"
        "  CentOS/RHEL:    sudo yum install cryptopp-devel\n"
        "  Fedora:         sudo dnf install cryptopp-devel\n"
        "  Arch Linux:     sudo pacman -S crypto++\n"
        "  macOS:          brew install cryptopp\n"
        "  Windows:        vcpkg install cryptopp\n"
        "\n"
        "🔨 BUILD FROM SOURCE (latest stable v8.9.0):\n"
        "  wget https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip\n"
        "  unzip cryptopp890.zip && cd cryptopp\n"
        "  make -j\\$(nproc) && sudo make install\n"
        "  sudo ldconfig  # Linux only\n"
        "\n"
        "📋 TROUBLESHOOTING:\n"
        "  Check pkg-config: pkg-config --exists libcrypto++\n"
        "  Check library:    find /usr -name '*crypto*' -type f 2>/dev/null\n"
        "  Check headers:    find /usr -name 'cryptlib.h' 2>/dev/null"
        "  make -j\$(nproc) && sudo make install\n"
        "  sudo ldconfig  # Linux only\n"
        "\n"
        "🔗 More info: https://cryptopp.com/wiki/Linux\n"
        "\n"
        "After installation, re-run cmake to detect the library."
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