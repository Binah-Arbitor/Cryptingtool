# CryptingTool App Icon Design Specification

## Overview
Create an Android app icon featuring a CPU chip with a glowing keyhole symbol, representing hardware-level encryption.

## Design Requirements

### Core Symbol: CPU Chip (Top-down view)
- **Shape**: Square CPU chip with rounded corners
- **Size**: Should fill approximately 70-80% of the icon canvas
- **Material**: Metallic appearance with subtle reflections
- **Color**: Dark metallic gray to silver gradient (#2a2a2a to #4a4a4a)
- **Surface**: Slightly textured metallic finish with micro-details

### Background: Circuit Board
- **Base Color**: Very dark background (#1a1a1a to #0d0d0d)
- **PCB Traces**: 
  - Color: Copper/gold (#b8860b with slight glow)
  - Pattern: Circuit traces radiating from CPU pins
  - Width: Thin lines (1-2px at 192px resolution)
  - Connection: Should visually connect to CPU pin locations
- **Components**: Small surface-mount components scattered around (optional)

### CPU Pin Details
- **Pin Count**: 32-64 pins around the perimeter (doesn't need to be exact)
- **Pin Style**: Small metallic rectangles extending from chip edges
- **Color**: Bright metallic silver (#c0c0c0)
- **Spacing**: Evenly distributed around all four sides

### Focal Point: Glowing Keyhole Symbol
- **Location**: Center of CPU chip surface
- **Symbol**: Traditional keyhole shape (circle with extending rectangular slot)
- **Glow Effect**:
  - Inner glow: Bright teal (#00ffff)
  - Outer glow: Softer teal with transparency
  - Glow radius: Should extend 8-12px from keyhole edge
  - Animation note: Static for icon, but should suggest internal light
- **Keyhole Color**: The keyhole itself should appear as if etched/cut into the metal
- **Size**: Keyhole should be approximately 25-30% of CPU chip size

### CPU Edge Highlight
- **Effect**: Faint teal outline around CPU edges
- **Color**: Teal (#008080) with 40-60% opacity
- **Width**: 1-2px subtle highlight
- **Style**: Should suggest the glow from internal keyhole affecting chip edges

## Technical Specifications

### Icon Sizes (Android)
Create icons for all Android densities:
- **mdpi**: 48x48px
- **hdpi**: 72x72px  
- **xhdpi**: 96x96px
- **xxhdpi**: 144x144px
- **xxxhdpi**: 192x192px

### Adaptive Icon (Android 8+)
- **Foreground**: CPU chip with keyhole (transparent background)
- **Background**: Dark circuit board pattern
- **Safe zone**: Keep important elements within 66dp diameter
- **Keyhole glow**: Should be visible even when masked

### Color Palette
```
Primary Dark: #1a1a1a (background)
CPU Metal: #2a2a2a to #4a4a4a (gradient)
CPU Pins: #c0c0c0 (bright silver)
PCB Traces: #b8860b (copper/gold)
Keyhole Glow: #00ffff (bright teal)
Edge Highlight: #008080 (teal, 50% opacity)
```

### Visual Hierarchy
1. **Primary**: Glowing keyhole (most prominent)
2. **Secondary**: CPU chip outline and surface
3. **Tertiary**: PCB traces and background details
4. **Subtle**: CPU pins and edge highlights

### Design Notes
- The glow should suggest internal illumination, not external lighting
- Circuit traces should look functional and purposeful
- Overall feel should be high-tech and secure
- Avoid overly complex details that won't be visible at small sizes
- Ensure good contrast for visibility on both light and dark backgrounds

## File Organization
```
assets/icons/
├── app_icon.png (1024x1024 master)
├── app_icon_foreground.png (adaptive icon)
└── android/
    ├── mipmap-mdpi/ic_launcher.png (48x48)
    ├── mipmap-hdpi/ic_launcher.png (72x72)
    ├── mipmap-xhdpi/ic_launcher.png (96x96)
    ├── mipmap-xxhdpi/ic_launcher.png (144x144)
    └── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

## Implementation Steps
1. Create master 1024x1024 design
2. Generate all required sizes maintaining visual consistency
3. Test visibility at smallest size (48x48)
4. Ensure adaptive icon works with various mask shapes
5. Validate contrast and readability