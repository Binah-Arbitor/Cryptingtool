# APK Builder Manual Workflow

This repository includes a manual APK builder workflow based on GitHub Actions v4 that supports both debug and release builds.

## 🚀 How to Use

### Manual Trigger
1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. Select "Build APK (Manual)" workflow
4. Click "Run workflow"
5. Choose your build options:
   - **Build Mode**: `debug` or `release`
   - **App Name**: Name for your APK (default: `CryptingTool`)
   - **Flutter Version**: Flutter SDK version (default: `stable`)
   - **Include C++ Libraries**: Whether to bundle C++ libraries (default: `true`)

### Build Modes

#### Debug Mode
- Includes debug symbols and information
- Larger APK size
- Suitable for development and testing
- Allows debugging with development tools

#### Release Mode
- Optimized and minified
- Smaller APK size
- Suitable for production distribution
- Performance optimized

## 📱 Output

### Artifacts
- APK files are automatically uploaded as GitHub artifacts
- Artifacts are retained for 30 days
- Named as: `{AppName}-{BuildMode}-apk`

### Build Information
- Package path and size are displayed in the workflow summary
- Detailed build logs available in the workflow run
- APK files listed in the build results

## 🔧 Features

### Supported Platforms
- ✅ Android APK building
- ✅ Debug and Release modes
- ✅ C++ library integration
- ✅ Custom app naming
- ✅ Flexible Flutter version selection

### Technical Details
- Uses GitHub Actions v4 (Node.js 20 runtime)
- Composite action architecture for better performance
- Automatic Flutter SDK setup
- Java 17 setup for Android builds
- Cross-platform C++ compilation support

## 📋 Requirements

### Repository Structure
Your repository should contain:
```
your-repo/
├── lib/                  # Flutter Dart code
├── pubspec.yaml         # Flutter dependencies (will be created if missing)
├── src/                 # C++ source files (optional)
├── include/             # C++ header files (optional)
└── android/             # Android platform files (created automatically)
```

### Automatic Setup
The workflow automatically handles:
- Flutter project initialization (if needed)
- Android platform setup
- Dependency installation
- C++ library compilation
- APK packaging

## 🏗️ Build Process

1. **Setup**: Java 17, Flutter SDK installation
2. **Dependencies**: `flutter pub get`
3. **C++ Compilation**: Builds native libraries if present
4. **Flutter Build**: `flutter build apk --{mode}`
5. **Packaging**: Copies APK and libraries to output directory
6. **Upload**: Artifacts uploaded to GitHub

## 📊 Workflow Outputs

The workflow provides:
- `package-path`: Path to the generated APK package
- `package-size`: Size of the generated package
- Build summary with file listings
- Automatic artifact upload

## 🔍 Troubleshooting

### Common Issues
1. **No APK Generated**: Check Flutter project structure and dependencies
2. **Build Fails**: Verify Java and Android SDK setup
3. **Large APK Size**: Use release mode for smaller, optimized builds
4. **C++ Errors**: Check C++ source file locations and compilation settings

### Debug Information
- All build logs are available in the workflow run details
- Use debug mode for more verbose logging
- Check the "Display Build Results" step for file listings

## 🎯 Example Usage

### Simple Release Build
```yaml
# Manual trigger with these inputs:
Build Mode: release
App Name: MyAwesomeApp
Flutter Version: stable
Include C++ Libraries: true
```

### Development Testing
```yaml
# Manual trigger with these inputs:
Build Mode: debug
App Name: MyApp-Dev
Flutter Version: stable
Include C++ Libraries: false
```

This manual workflow is perfect for:
- 🧪 Testing builds before releases
- 📦 Creating custom APK variants
- 🔍 Debugging build issues
- 🚀 Quick prototype distribution