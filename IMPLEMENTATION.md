# CryptingTool - High-Performance Flutter UI

A sophisticated Flutter UI implementation for a high-performance file encryption/decryption utility with PCB/Cyber-Tech aesthetics.

## 🎯 Project Overview

This Flutter application provides a professional, cyber-themed user interface for a C++ Crypto++ library-based encryption tool. The UI features a dark mode design with circuit board aesthetics, real-time logging, and comprehensive encryption configuration options.

## ✨ Key Features

### 🎨 PCB/Cyber-Tech Design Theme
- **Dark Mode**: Deep off-black background (#0A0A0A) with professional contrast
- **Accent Colors**: Teal (#00FFD4) and Cyan (#00E5FF) for active elements
- **Success Indicators**: Lime green (#76FF03) for completion states
- **Typography**: Google Fonts Fira Code for technical aesthetic
- **Circuit Patterns**: Subtle PCB-inspired visual elements

### 🛠️ Core Functionality Panels

#### 1. File I/O Control Panel
- Drag-and-drop file selection interface
- Circuit board styled file drop zone
- Dual-action encrypt/decrypt buttons with glow effects
- File information display (name, size, type, modification date)
- Visual feedback for processing states

#### 2. Encryption Configuration Panel
- **Dynamic Algorithm Selection**: AES, Serpent, Twofish, RC6, Blowfish, CAST-128
- **Key Length Options**: 128, 192, 256 bits (algorithm-dependent)
- **Operation Modes**: CBC, GCM, ECB, CFB, OFB, CTR
- **Secure Password Input**: Hide/show functionality with validation
- **Configuration Summary**: Real-time security level assessment

#### 3. Advanced Settings Panel
- **Multithreading Control**: Dynamic thread count adjustment
- **System Detection**: Automatic CPU core detection
- **Performance Presets**: Conservative, Balanced, Aggressive modes
- **Memory Optimization**: Buffer size and usage display
- **Performance Impact**: Real-time guidance and recommendations

#### 4. Real-Time Log Console
- **Color-Coded Logging**: INFO (blue), SUCCESS (green), WARNING (amber), ERROR (red)
- **Auto-Scroll**: Automatic scrolling to latest entries
- **Expandable Interface**: Collapsible panel for space optimization
- **Log Filtering**: Level-based entry counting and indicators
- **Timestamp Display**: Precise millisecond logging
- **Source Tagging**: Component-based log categorization

#### 5. Status Bar & Progress Tracking
- **Real-Time Progress**: Chunk-based processing visualization
- **Performance Metrics**: Speed, ETA, elapsed time display
- **Status Indicators**: Visual status with animated elements
- **Processing Statistics**: Detailed operation information

### 🏗️ Architecture & Structure

#### Modular Widget Design
```
lib/
├── models/
│   ├── encryption_config.dart    # Encryption settings and algorithms
│   ├── log_entry.dart            # Log entry data structures
│   └── app_state.dart            # File info and processing state
├── providers/
│   └── app_state_provider.dart   # Central state management
├── screens/
│   └── crypting_tool_screen.dart # Main application screen
├── theme/
│   └── app_theme.dart            # PCB/Cyber theme configuration
└── widgets/
    ├── file_io_panel.dart        # File selection and actions
    ├── encryption_config_panel.dart # Crypto configuration
    ├── advanced_settings_panel.dart # Threading and advanced options
    ├── log_console_panel.dart    # Real-time logging interface
    └── status_bar.dart           # Progress and status display
```

#### State Management
- **Provider Pattern**: Clean, reactive state management
- **Stream-Based Logging**: Real-time log entry streaming
- **Configuration Validation**: Dynamic validation and constraints
- **Processing Simulation**: Realistic progress tracking for demonstration

### 🔧 Technical Implementation

#### Dependencies
```yaml
dependencies:
  flutter: ^3.3.0
  provider: ^6.1.1          # State management
  file_picker: ^8.0.0+1     # File selection
  google_fonts: ^6.1.0      # Fira Code typography
  ffi: ^2.1.0               # C++ library integration
```

#### Key Design Patterns
- **Reactive UI**: Provider-based state updates
- **Modular Components**: Reusable, maintainable widgets
- **Theme System**: Centralized styling with Google Fonts
- **Animation Framework**: Smooth transitions and visual feedback
- **Responsive Design**: Adaptive layouts for different screen sizes

### 🚀 Backend Integration Ready

#### C++ Library Interface
- **FFI Integration**: Foreign Function Interface for C++ communication
- **Isolate Support**: Prepared for background processing
- **Stream Communication**: Ready for real-time C++ → Flutter data flow
- **Memory Management**: Structured for efficient native library interaction

#### Processing Architecture
- **Multi-threading**: Configurable worker thread management
- **Chunk Processing**: Designed for large file handling
- **Progress Reporting**: Real-time processing feedback
- **Error Handling**: Comprehensive error state management

## 🖥️ UI Screenshots

The implemented UI features:
- Modern PCB/cyber aesthetic with professional dark theme
- Intuitive file selection with drag-drop functionality
- Comprehensive encryption configuration options
- Real-time log console with color-coded entries
- Advanced multithreading controls with system optimization
- Responsive progress tracking and status display

## 📦 Installation & Usage

### Prerequisites
- Flutter SDK 3.3.0 or higher
- Dart SDK 2.19.0 or higher
- Platform-specific development tools (Android Studio, Xcode, etc.)

### Setup
```bash
# Clone the repository
git clone https://github.com/Binah-Arbitor/Cryptingtool.git
cd Cryptingtool

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Development
```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build linux        # Linux
flutter build windows      # Windows
flutter build macos        # macOS
flutter build web          # Web
```

## 🔮 Future Enhancements

- **C++ Backend Integration**: Complete Crypto++ library integration
- **File Format Support**: Extended file type handling
- **Batch Processing**: Multiple file encryption/decryption
- **Key Management**: Advanced key storage and management
- **Cloud Integration**: Secure cloud storage options
- **Performance Profiling**: Built-in performance analysis tools

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**Built with Flutter 💙 | Designed for Security 🔐 | Optimized for Performance ⚡**