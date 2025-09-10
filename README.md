# CryptingTool Flutter App

A Flutter-based encryption tool app with a distinctive CPU chip and keyhole icon design.

## App Icon

The app features a custom icon design representing hardware-level encryption:

### Design Concept
- **Core Symbol**: Top-down view of a CPU (Central Processing Unit) chip
- **Background**: Dark, detailed circuit board with PCB traces
- **Focal Point**: Glowing keyhole symbol etched on the CPU surface
- **Theme**: Hardware-level security and encryption

### Icon Creation

#### Prerequisites
1. Install Flutter and required dependencies
2. Ensure `flutter_launcher_icons` package is included (already configured in `pubspec.yaml`)

#### Steps to Generate Icons

1. **Create Master Icon Files**
   - Create `assets/icons/app_icon.png` (1024x1024px) following the design specification in `ICON_SPECIFICATION.md`
   - Create `assets/icons/app_icon_foreground.png` (1024x1024px) for adaptive icons

2. **Design Specifications** (see `ICON_SPECIFICATION.md` for full details)
   - CPU chip: Metallic gray with rounded corners
   - Background: Dark circuit board (#1a1a1a)
   - Keyhole: Bright teal glow (#00ffff)
   - PCB traces: Copper/gold (#b8860b)
   - CPU edges: Faint teal outline

3. **Generate Icon Files**
   ```bash
   # Install dependencies
   flutter pub get
   
   # Run the icon generation script
   ./generate_icons.sh
   
   # Generate icons using flutter_launcher_icons
   flutter pub run flutter_launcher_icons:main
   ```

4. **Generated Icon Sizes**
   The tool will generate icons for all Android densities:
   - mdpi: 48x48px
   - hdpi: 72x72px
   - xhdpi: 96x96px
   - xxhdpi: 144x144px
   - xxxhdpi: 192x192px

#### Icon Configuration

The icon configuration is defined in `pubspec.yaml`:
```yaml
flutter_icons:
  android: true
  ios: false
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#1a1a1a"
  adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
```

### Project Structure

```
cryptingtool/
├── lib/
│   └── main.dart                 # Main Flutter app
├── android/
│   └── app/
│       ├── build.gradle          # Android build configuration
│       └── src/main/
│           ├── AndroidManifest.xml
│           ├── kotlin/           # Main Activity
│           └── res/
│               └── mipmap-*/     # Generated icon files
├── assets/
│   └── icons/                    # Master icon files (to be created)
├── pubspec.yaml                  # Flutter configuration
├── ICON_SPECIFICATION.md         # Detailed icon design specs
└── generate_icons.sh             # Icon generation helper script
```

### Development

#### Running the App
```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

#### Building for Release
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### Icon Design Tools

Recommended tools for creating the icon:
- **Vector Graphics**: Adobe Illustrator, Inkscape, or Figma
- **Raster Graphics**: Adobe Photoshop, GIMP, or Canva
- **Icon-specific Tools**: IconJar, Nucleo, or Icon8

### Testing Icons

After generating icons, test them:
1. Install the app on different Android devices
2. Check icon visibility on various launcher backgrounds
3. Verify adaptive icon behavior on Android 8+ devices
4. Test different device densities

### Customization

To modify the icon design:
1. Update the master files in `assets/icons/`
2. Adjust colors/design according to `ICON_SPECIFICATION.md`
3. Re-run the icon generation process
4. Test on devices

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.