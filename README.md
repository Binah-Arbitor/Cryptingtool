# CryptingTool - High-Performance Encryption Utility

A high-performance, multi-threaded file encryption/decryption utility for Android built with Flutter and powered by a C++ backend using the Crypto++ library.

## Features

### 🎨 PCB/Cyber-Tech UI Theme
- **Dark Mode**: Deep off-black background (#0A0A0A) with teal/cyan accents
- **Technical Typography**: Fira Code and IBM Plex Mono fonts for a professional, technical feel
- **Circuit Board Aesthetics**: Subtle lines and borders resembling PCB traces
- **Neon Glow Effects**: Interactive elements with cyan glow when active

### 🔐 Cryptographic Features
- **Multiple Algorithms**: AES, Serpent, Twofish, RC6, Blowfish
- **Flexible Key Lengths**: 128, 192, 256 bits (algorithm-dependent)
- **Various Modes**: CBC, GCM, ECB, CFB, OFB (algorithm-dependent)
- **Dynamic Configuration**: Dropdowns automatically update based on selected algorithm

### 🚀 Performance
- **Multi-threading Support**: Configurable thread count up to system processor limit
- **Background Processing**: Operations run in dedicated Isolate using FFI
- **Real-time Progress**: Live progress updates and status tracking
- **System Optimization**: Recommends optimal thread configuration

### 📱 User Interface
- **5-Panel Architecture**:
  1. **File Selection**: Drag-and-drop style file picker with detailed file info
  2. **Action Buttons**: Glowing encrypt/decrypt buttons with smart state management
  3. **Encryption Config**: Dynamic algorithm, key length, and mode selection
  4. **Advanced Settings**: Expandable multi-threading configuration
  5. **Live Console**: Real-time log output with color-coded message types
  6. **Status Bar**: Progress indicator and current operation status

### 🏗️ Architecture
- **State Management**: Riverpod for reactive, scalable state management
- **Clean Architecture**: Organized into models, services, views, and widgets
- **FFI Integration**: Seamless communication with C++ backend via Isolates
- **Reactive UI**: Dynamic updates based on user selections and operation state

## Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android development environment

### Dependencies
The project uses the following key packages:
- `flutter_riverpod` - State management
- `file_picker` - File selection
- `flutter_glow` - Neon glow effects
- `dotted_border` - UI enhancements
- `device_info_plus` - System information

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Download and place the following fonts in `assets/fonts/`:
   - Fira Code (Regular & Bold)
   - IBM Plex Mono (Regular & Bold)
4. Build and run: `flutter run`

## Project Structure
```
lib/
├── main.dart              # App entry point
├── theme.dart            # PCB/Cyber-tech theme configuration
├── models/               # Data models
│   ├── encryption_config.dart
│   ├── file_info.dart
│   └── log_entry.dart
├── services/             # Business logic
│   ├── app_state.dart    # Riverpod providers and state
│   └── cryptography_service.dart
├── views/                # Main screens
│   └── main_screen.dart
└── widgets/              # Reusable UI components
    ├── file_selection_panel.dart
    ├── action_buttons_panel.dart
    ├── encryption_config_panel.dart
    ├── advanced_settings_panel.dart
    ├── live_console_panel.dart
    └── status_bar_panel.dart
```

## Usage

1. **Select File**: Tap the file selection area to choose a file for encryption/decryption
2. **Configure Encryption**: Choose algorithm, key length, mode, and enter password
3. **Adjust Settings**: Optionally configure advanced settings like thread count
4. **Execute Operation**: Press ENCRYPT or DECRYPT button
5. **Monitor Progress**: Watch real-time progress in the console and status bar

## State Management

The app uses Riverpod for state management with the following key providers:
- `selectedFileProvider` - Currently selected file
- `encryptionConfigProvider` - Current encryption configuration
- `logEntriesProvider` - Console log entries
- `operationStatusProvider` - Current operation status
- `operationProgressProvider` - Progress percentage

## Backend Integration

The UI communicates with a C++ backend through:
- **Isolate-based Processing**: Background operations don't block the UI
- **FFI Interface**: Direct communication with Crypto++ library
- **Stream-based Updates**: Real-time progress and log updates
- **Error Handling**: Comprehensive error reporting and recovery

## Performance Optimization

- **Smart Threading**: Recommends using 80% of available CPU cores
- **Memory Efficient**: Uses ListView.builder for large log outputs
- **Reactive Updates**: Only rebuilds UI components when necessary
- **Auto-scrolling Console**: Automatically follows latest log entries

## Customization

The theme can be customized by modifying `theme.dart`:
- **Colors**: Adjust the PCB color palette
- **Typography**: Change fonts and text styles
- **UI Elements**: Modify borders, shadows, and decorations

## Future Enhancements

- [ ] File batch processing
- [ ] Progress persistence across app restarts
- [ ] Custom encryption parameters
- [ ] Export/import configuration profiles
- [ ] Dark/Light theme toggle
- [ ] Additional cipher algorithms

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.