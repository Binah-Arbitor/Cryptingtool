#!/bin/bash

echo "=== CryptingTool Flutter UI Validation ==="
echo ""

# Check project structure
echo "1. Project Structure:"
echo "   - pubspec.yaml: $([ -f pubspec.yaml ] && echo "✓" || echo "✗")"
echo "   - main.dart: $([ -f lib/main.dart ] && echo "✓" || echo "✗")"
echo "   - theme: $([ -f lib/theme/app_theme.dart ] && echo "✓" || echo "✗")"
echo "   - models: $([ -f lib/models/encryption_models.dart ] && echo "✓" || echo "✗")"
echo "   - services: $([ -f lib/services/backend_service.dart ] && echo "✓" || echo "✗")"
echo "   - widgets: $([ $(find lib/widgets -name "*.dart" | wc -l) -eq 5 ] && echo "✓ (5 widgets)" || echo "✗")"
echo ""

# Check key components
echo "2. Key Components:"
echo "   - FileIOPanel: $(grep -q "class FileIOPanel" lib/widgets/file_io_panel.dart && echo "✓" || echo "✗")"
echo "   - EncryptionConfigPanel: $(grep -q "class EncryptionConfigPanel" lib/widgets/encryption_config_panel.dart && echo "✓" || echo "✗")"
echo "   - AdvancedSettingsPanel: $(grep -q "class AdvancedSettingsPanel" lib/widgets/advanced_settings_panel.dart && echo "✓" || echo "✗")"
echo "   - LogConsolePanel: $(grep -q "class LogConsolePanel" lib/widgets/log_console_panel.dart && echo "✓" || echo "✗")"
echo "   - StatusPanel: $(grep -q "class StatusPanel" lib/widgets/status_panel.dart && echo "✓" || echo "✗")"
echo ""

# Check theme colors
echo "3. PCB/Cyber-Tech Theme:"
echo "   - Deep Off-Black: $(grep -q "0xFF0A0A0A" lib/theme/app_theme.dart && echo "✓" || echo "✗")"
echo "   - Teal/Cyan: $(grep -q "0xFF00D4AA" lib/theme/app_theme.dart && echo "✓" || echo "✗")"
echo "   - Lime Green: $(grep -q "0xFF39FF14" lib/theme/app_theme.dart && echo "✓" || echo "✗")"
echo "   - Monospace fonts: $(grep -q "fontFamily: 'monospace'" lib/theme/app_theme.dart && echo "✓" || echo "✗")"
echo ""

# Check models and enums
echo "4. Data Models:"
echo "   - EncryptionAlgorithm: $(grep -q "enum EncryptionAlgorithm" lib/models/encryption_models.dart && echo "✓" || echo "✗")"
echo "   - KeyLength: $(grep -q "enum KeyLength" lib/models/encryption_models.dart && echo "✓" || echo "✗")"
echo "   - OperationMode: $(grep -q "enum OperationMode" lib/models/encryption_models.dart && echo "✓" || echo "✗")"
echo "   - LogLevel: $(grep -q "enum LogLevel" lib/models/encryption_models.dart && echo "✓" || echo "✗")"
echo ""

# Check backend service
echo "5. Backend Service:"
echo "   - BackendService class: $(grep -q "class BackendService" lib/services/backend_service.dart && echo "✓" || echo "✗")"
echo "   - Stream controllers: $(grep -q "StreamController" lib/services/backend_service.dart && echo "✓" || echo "✗")"
echo "   - Encryption/Decryption methods: $(grep -q "startEncryption\|startDecryption" lib/services/backend_service.dart && echo "✓" || echo "✗")"
echo ""

# Check dependencies
echo "6. Dependencies:"
echo "   - file_picker: $(grep -q "file_picker:" pubspec.yaml && echo "✓" || echo "✗")"
echo "   - path_provider: $(grep -q "path_provider:" pubspec.yaml && echo "✓" || echo "✗")"
echo "   - provider: $(grep -q "provider:" pubspec.yaml && echo "✓" || echo "✗")"
echo "   - flutter_riverpod: $(grep -q "flutter_riverpod:" pubspec.yaml && echo "✓" || echo "✗")"
echo "   - equatable: $(grep -q "equatable:" pubspec.yaml && echo "✓" || echo "✗")"
echo ""

# Statistics
echo "7. Statistics:"
echo "   - Total Dart files: $(find . -name "*.dart" | wc -l)"
echo "   - Total lines of code: $(find . -name "*.dart" -exec wc -l {} \; | awk '{sum+=$1} END {print sum}')"
echo "   - Main app file size: $(wc -l < lib/main.dart) lines"
echo "   - Theme file size: $(wc -l < lib/theme/app_theme.dart) lines"
echo ""

echo "=== Validation Complete ==="