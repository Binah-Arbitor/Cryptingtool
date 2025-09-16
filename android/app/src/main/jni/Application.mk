APP_ABI := arm64-v8a armeabi-v7a x86_64
APP_PLATFORM := android-32
APP_STL := c++_shared

# Build configuration (will be overridden by gradle arguments)
APP_OPTIM := release

# Support flexible page sizes for modern Android
APP_CPPFLAGS := -DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON

# Enable modern C++ features
APP_CPPFLAGS += -std=c++17