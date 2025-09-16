cmake_minimum_required(VERSION 3.22.1)

project(cryptingtool)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include directories - reference parent project source
include_directories(../../../../../include)

# Collect C/C++ sources from parent project
file(GLOB SRC_FILES 
    ../../../../../src/*.cpp 
    ../../../../../src/*.cc 
    ../../../../../src/*.c
)

# Check if we have any sources to build
list(LENGTH SRC_FILES SRC_COUNT)
if(SRC_COUNT GREATER 0)
    # Create the shared library for Android
    add_library(cryptingtool SHARED ${SRC_FILES})
    
    # Link with Android log library
    target_link_libraries(cryptingtool log)
    
    # Set output properties
    set_target_properties(cryptingtool PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    message(STATUS "cryptingtool: Building with ${SRC_COUNT} source files")
else()
    # Create a minimal placeholder to avoid Android build failure
    # This allows the build to succeed even when no C++ sources are present
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/placeholder.cpp 
         "// Placeholder file for Android native build when no C++ sources are found\n"
         "extern \"C\" {\n"
         "    void cryptingtool_placeholder() {\n"
         "        // Empty placeholder function\n"
         "    }\n"
         "}\n")
         
    add_library(cryptingtool SHARED ${CMAKE_CURRENT_BINARY_DIR}/placeholder.cpp)
    target_link_libraries(cryptingtool log)
    
    message(STATUS "cryptingtool: No C++ sources found, using placeholder")
endif()