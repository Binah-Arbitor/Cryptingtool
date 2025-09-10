# Icon Assets

This directory should contain the master icon files for the CryptingTool app.

## Required Files:

### app_icon.png (1024x1024)
The main app icon featuring:
- CPU chip (top-down view) with metallic appearance
- Dark circuit board background with copper traces  
- Glowing keyhole symbol in center of CPU
- Teal edge highlights on CPU

### app_icon_foreground.png (1024x1024)
Adaptive icon foreground layer:
- Same CPU chip and keyhole design
- Transparent background
- Optimized for circular/square/rounded masks

## Generation:
After creating these files, run:
```bash
flutter pub run flutter_launcher_icons:main
```

This will generate all required icon sizes for Android.
