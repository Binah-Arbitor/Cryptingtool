import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/encryption_models.dart';

class EncryptionConfigPanel extends StatefulWidget {
  final EncryptionConfig config;
  final Function(EncryptionConfig) onConfigChanged;
  final bool isEnabled;

  const EncryptionConfigPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
    this.isEnabled = true,
  });

  @override
  State<EncryptionConfigPanel> createState() => _EncryptionConfigPanelState();
}

class _EncryptionConfigPanelState extends State<EncryptionConfigPanel> {
  bool _passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.text = widget.config.password;
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    final newConfig = widget.config.copyWith(password: _passwordController.text);
    widget.onConfigChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with circuit pattern
            Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: AppTheme.tealCyan,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'ENCRYPTION CONFIGURATION',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.tealCyan,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.tealCyan.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Configuration grid
            _buildConfigurationGrid(),
            
            const SizedBox(height: 20),
            
            // Password field
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildAlgorithmDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildKeyLengthDropdown()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildOperationModeDropdown()),
            const SizedBox(width: 16),
            Expanded(child: _buildAlgorithmInfo()),
          ],
        ),
      ],
    );
  }

  Widget _buildAlgorithmDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('ALGORITHM', Icons.memory_outlined),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mediumGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.tealCyan.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EncryptionAlgorithm>(
              value: widget.config.algorithm,
              isExpanded: true,
              dropdownColor: AppTheme.cardGray,
              style: Theme.of(context).textTheme.bodyMedium,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.tealCyan,
              ),
              onChanged: widget.isEnabled ? _onAlgorithmChanged : null,
              items: EncryptionAlgorithm.values.map((algorithm) {
                return DropdownMenuItem<EncryptionAlgorithm>(
                  value: algorithm,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.tealCyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        algorithm.displayName,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyLengthDropdown() {
    final availableKeyLengths = AlgorithmCompatibility.getAvailableKeyLengths(widget.config.algorithm);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('KEY LENGTH', Icons.vpn_key_outlined),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mediumGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.tealCyan.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<KeyLength>(
              value: availableKeyLengths.contains(widget.config.keyLength) 
                  ? widget.config.keyLength 
                  : availableKeyLengths.first,
              isExpanded: true,
              dropdownColor: AppTheme.cardGray,
              style: Theme.of(context).textTheme.bodyMedium,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.tealCyan,
              ),
              onChanged: widget.isEnabled ? _onKeyLengthChanged : null,
              items: availableKeyLengths.map((keyLength) {
                return DropdownMenuItem<KeyLength>(
                  value: keyLength,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.limeGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        keyLength.toString(),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOperationModeDropdown() {
    final availableModes = AlgorithmCompatibility.getAvailableOperationModes(widget.config.algorithm);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('OPERATION MODE', Icons.settings_outlined),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mediumGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.tealCyan.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<OperationMode>(
              value: availableModes.contains(widget.config.operationMode) 
                  ? widget.config.operationMode 
                  : availableModes.first,
              isExpanded: true,
              dropdownColor: AppTheme.cardGray,
              style: Theme.of(context).textTheme.bodyMedium,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.tealCyan,
              ),
              onChanged: widget.isEnabled ? _onOperationModeChanged : null,
              items: availableModes.map((mode) {
                return DropdownMenuItem<OperationMode>(
                  value: mode,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.warningOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        mode.displayName,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlgorithmInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('ALGORITHM INFO', Icons.info_outline),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.cardGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.infoBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Block Cipher',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.infoBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getAlgorithmDescription(widget.config.algorithm),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('PASSWORD', Icons.lock_outline),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          enabled: widget.isEnabled,
          obscureText: !_passwordVisible,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            hintText: 'Enter encryption password...',
            prefixIcon: Icon(
              Icons.vpn_key,
              color: AppTheme.tealCyan,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.lightGray,
                size: 20,
              ),
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.tealCyan.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.tealCyan, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 14,
              color: AppTheme.infoBlue,
            ),
            const SizedBox(width: 6),
            Text(
              'Use a strong password (8+ chars, mixed case, numbers, symbols)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.infoBlue,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.tealCyan,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.tealCyan,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  String _getAlgorithmDescription(EncryptionAlgorithm algorithm) {
    switch (algorithm) {
      case EncryptionAlgorithm.aes:
        return 'Advanced Encryption Standard - Industry standard symmetric cipher';
      case EncryptionAlgorithm.serpent:
        return 'One of the AES finalists - High security, slower than AES';
      case EncryptionAlgorithm.twofish:
        return 'AES finalist by Bruce Schneier - Fast and secure';
      case EncryptionAlgorithm.rc6:
        return 'Rivest Cipher 6 - AES finalist with variable parameters';
      case EncryptionAlgorithm.blowfish:
        return 'Fast cipher by Bruce Schneier - Variable key length';
      case EncryptionAlgorithm.camellia:
        return 'Japanese cipher equivalent to AES - Good performance';
    }
  }

  void _onAlgorithmChanged(EncryptionAlgorithm? algorithm) {
    if (algorithm != null) {
      final availableKeyLengths = AlgorithmCompatibility.getAvailableKeyLengths(algorithm);
      final availableModes = AlgorithmCompatibility.getAvailableOperationModes(algorithm);
      
      final newConfig = widget.config.copyWith(
        algorithm: algorithm,
        keyLength: availableKeyLengths.contains(widget.config.keyLength) 
            ? widget.config.keyLength 
            : availableKeyLengths.first,
        operationMode: availableModes.contains(widget.config.operationMode) 
            ? widget.config.operationMode 
            : availableModes.first,
      );
      
      widget.onConfigChanged(newConfig);
    }
  }

  void _onKeyLengthChanged(KeyLength? keyLength) {
    if (keyLength != null) {
      final newConfig = widget.config.copyWith(keyLength: keyLength);
      widget.onConfigChanged(newConfig);
    }
  }

  void _onOperationModeChanged(OperationMode? mode) {
    if (mode != null) {
      final newConfig = widget.config.copyWith(operationMode: mode);
      widget.onConfigChanged(newConfig);
    }
  }
}