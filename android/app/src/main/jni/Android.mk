LOCAL_PATH := $(call my-dir)

# Clear variables
include $(CLEAR_VARS)

# Module name - this will create libcryptingtool.so
LOCAL_MODULE := cryptingtool

# Include directories
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../../../include

# Source files from parent project
LOCAL_SRC_FILES := \
    ../../../../../src/crypting.cpp \
    ../../../../../src/crypto_bridge.cpp

# Compiler flags for C++
LOCAL_CPPFLAGS := -std=c++17 -fno-exceptions -fno-rtti -DANDROID -DCRYPTOPP_DISABLE_ASM=1

# For release builds, add optimization flags
ifeq ($(APP_OPTIM),release)
    LOCAL_CPPFLAGS += -Os -DNDEBUG
else
    LOCAL_CPPFLAGS += -O0 -g -DDEBUG
endif

# Link with standard libraries
LOCAL_LDLIBS := -llog

# Build shared library
include $(BUILD_SHARED_LIBRARY)