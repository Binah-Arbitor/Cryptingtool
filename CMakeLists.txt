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
)

# Create shared library
add_library(crypting SHARED ${SOURCES})

# Create static library (for platforms that need it)
add_library(crypting_static STATIC ${SOURCES})

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