# CryptingTool App Icon Design

## Design Concept
The CryptingTool app icon features a **top-down view of a CPU chip** with a **glowing keyhole symbol** etched into its metallic surface, set against a **dark circuit board background**.

## Visual Elements

### 1. Core Symbol - CPU Chip
- **Shape**: Square chip with rounded corners (160x160px at 512px canvas)
- **Material**: Metallic surface with gradient from dark gray (#2E2E2E) to deep black (#0A0A0A)
- **Outline**: Teal accent color (#00FFD4) with 2px stroke width
- **Glow Effect**: Subtle outer glow using the teal accent color

### 2. CPU Pins/Connectors
- **Layout**: Realistic CPU pin layout on all four sides
- **Color**: Medium gray (#4A4A4A) for metallic appearance
- **Size**: 8px wide pins with 2px rounded corners
- **Spacing**: Evenly distributed around chip perimeter

### 3. Circuit Board Background
- **Color**: Deep off-black (#0A0A0A) base
- **Traces**: Teal (#00FFD4) circuit traces with 30% opacity
- **Pattern**: Grid-based horizontal and vertical traces
- **Nodes**: Small circular connection points at intersections

### 4. Central Keyhole Symbol
- **Position**: Center of CPU chip, slightly offset upward
- **Design**: Traditional keyhole shape with circular top and rectangular bottom
- **Colors**: 
  - Glow: Radial gradient from teal (#00FFD4) to cyan (#00E5FF)
  - Fill: Solid teal (#00FFD4) 
  - Hole: Deep black (#0A0A0A) for contrast
- **Effects**: 
  - Inner glow suggesting hardware-level encryption
  - Multiple glow rings with decreasing opacity
  - 25px radius glow area

### 5. Corner Circuit Details
- **Elements**: L-shaped circuit traces in corners
- **Purpose**: Reinforces PCB aesthetic and frames the design
- **Opacity**: 40% to remain subtle background elements

## Color Palette

| Color Name | Hex Code | Usage |
|------------|----------|--------|
| Deep Off-Black | #0A0A0A | Primary background |
| Teal Accent | #00FFD4 | CPU outline, keyhole, traces |
| Cyan Accent | #00E5FF | Secondary glow effects |
| Dark Gray | #2E2E2E | CPU surface highlight |
| Medium Gray | #4A4A4A | CPU pins, details |

## Technical Implementation

### SVG Version (Scalable)
- **Main Icon**: `assets/icons/app_icon.svg` (512x512px)
- **Small Version**: `assets/icons/app_icon_128.svg` (128x128px)

### Custom Flutter Widget
- **File**: `lib/widgets/cpu_chip_icon.dart`
- **Class**: `CpuChipIcon` - Custom painted widget
- **Features**:
  - Scalable to any size
  - Configurable glow effects
  - Matches app theme colors
  - Optimized for performance

### Platform Integration
- **Flutter**: Added to `pubspec.yaml` assets
- **Android**: Icon directories created for multiple densities
- **Usage**: Integrated into app bar as primary app identifier

## Design Philosophy
The icon represents the core concept of **hardware-level encryption** - suggesting that cryptographic operations happen at the fundamental chip level, making them more secure and efficient. The glowing keyhole symbolizes the **secure access** provided by the encryption tool, while the circuit board aesthetic reinforces the **technical/professional** nature of the application.

## Accessibility
- High contrast between keyhole and background
- Clear visual hierarchy with the keyhole as primary focus
- Distinctive shape recognizable at small sizes
- Color choices provide sufficient contrast for visibility