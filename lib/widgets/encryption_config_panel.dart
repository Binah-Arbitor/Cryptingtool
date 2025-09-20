import 'package:flutter/material.dart';
import '../models/encryption_config.dart';
import '../theme/app_theme.dart';

class EncryptionConfigPanel extends StatefulWidget {
  final EncryptionConfig config;
  final Function(EncryptionConfig) onConfigChanged;
  final bool isLocked;

  const EncryptionConfigPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
    this.isLocked = false,
  });

  @override
  State<EncryptionConfigPanel> createState() => _EncryptionConfigPanelState();
}

class _EncryptionConfigPanelState extends State<EncryptionConfigPanel>
    with SingleTickerProviderStateMixin {
  late TextEditingController _passwordController;
  bool _passwordVisible = false;
  late AnimationController _lockAnimationController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.config.password);
    _lockAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.isLocked) {
      _lockAnimationController.forward();
    }
  }

  @override
  void didUpdateWidget(EncryptionConfigPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLocked != oldWidget.isLocked) {
      if (widget.isLocked) {
        _lockAnimationController.forward();
      } else {
        _lockAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _lockAnimationController.dispose();
    super.dispose();
  }

  void _updateConfig({
    EncryptionAlgorithm? algorithm,
    int? keySize,
    OperationMode? mode,
    String? password,
  }) {
    final newConfig = widget.config.copyWith(
      algorithm: algorithm,
      keySize: keySize,
      mode: mode,
      password: password,
    );
    widget.onConfigChanged(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedBuilder(
        animation: _lockAnimationController,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: widget.isLocked ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Stack(
                        children: [
                          const Icon(
                            Icons.security,
                            color: AppTheme.tealAccent,
                            size: 24,
                          ),
                          if (widget.isLocked)
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppTheme.deepOffBlack,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lock,
                                  color: AppTheme.errorRed,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'ENCRYPTION CONFIGURATION',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      if (widget.isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            // Info: Replaced deprecated 'withOpacity'
                            color: AppTheme.errorRed.withAlpha((255 * 0.2).round()),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              // Info: Replaced deprecated 'withOpacity'
                              color: AppTheme.errorRed.withAlpha((255 * 0.5).round()),
                            ),
                          ),
                          child: Text(
                            'LOCKED',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.errorRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Algorithm Selection
                  _buildSectionHeader('ENCRYPTION ALGORITHM'),
                  const SizedBox(height: 8),
                  _buildDropdown<EncryptionAlgorithm>(
                    value: widget.config.algorithm,
                    items: EncryptionAlgorithm.values,
                    itemBuilder: (algorithm) => _buildAlgorithmItem(algorithm),
                    onChanged: widget.isLocked
                        ? null
                        : (algorithm) {
                            if (algorithm != null) {
                              // Reset to first available key size and mode
                              final supportedKeySizes = algorithm.getSupportedKeySizes();
                              final supportedModes = algorithm.getSupportedModes();
                              _updateConfig(
                                algorithm: algorithm,
                                keySize: supportedKeySizes.first,
                                mode: supportedModes.first,
                              );
                            }
                          },
                    hint: 'Select Algorithm',
                  ),
                  const SizedBox(height: 16),

                  // Key Size Selection
                  _buildSectionHeader('KEY LENGTH'),
                  const SizedBox(height: 8),
                  _buildDropdown<int>(
                    value: widget.config.keySize,
                    items: widget.config.algorithm.getSupportedKeySizes(),
                    itemBuilder: (keySize) => _buildKeySizeItem(keySize),
                    onChanged: widget.isLocked
                        ? null
                        : (keySize) {
                            if (keySize != null) {
                              _updateConfig(keySize: keySize);
                            }
                          },
                    hint: 'Select Key Size',
                  ),
                  const SizedBox(height: 16),

                  // Operation Mode Selection
                  _buildSectionHeader('OPERATION MODE'),
                  const SizedBox(height: 8),
                  _buildDropdown<OperationMode>(
                    value: widget.config.mode,
                    items: widget.config.algorithm.getSupportedModes(),
                    itemBuilder: (mode) => _buildModeItem(mode),
                    onChanged: widget.isLocked
                        ? null
                        : (mode) {
                            if (mode != null) {
                              _updateConfig(mode: mode);
                            }
                          },
                    hint: 'Select Operation Mode',
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  _buildSectionHeader('ENCRYPTION PASSWORD'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    enabled: !widget.isLocked,
                    decoration: InputDecoration(
                      hintText: 'Enter secure password',
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: AppTheme.tealAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible 
                              ? Icons.visibility_off 
                              : Icons.visibility,
                          color: AppTheme.mediumGray,
                        ),
                        onPressed: widget.isLocked
                            ? null
                            : () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                      ),
                    ),
                    onChanged: widget.isLocked
                        ? null
                        : (password) {
                            _updateConfig(password: password);
                          },
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

                  const SizedBox(height: 16),

                  // Configuration Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // Info: Replaced deprecated 'withOpacity'
                      color: AppTheme.darkGray.withAlpha((255 * 0.3).round()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        // Info: Replaced deprecated 'withOpacity'
                        color: AppTheme.tealAccent.withAlpha((255 * 0.3).round()),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONFIGURATION SUMMARY',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.tealAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          'Algorithm:',
                          widget.config.algorithm.displayName,
                        ),
                        _buildSummaryRow(
                          'Key Size:',
                          '${widget.config.keySize} bits',
                        ),
                        _buildSummaryRow(
                          'Mode:',
                          widget.config.mode.displayName,
                        ),
                        _buildSummaryRow(
                          'Security:',
                          _getSecurityLevel(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppTheme.cyanAccent,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required void Function(T?)? onChanged,
    required String hint,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.mediumGray,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items.map((item) => DropdownMenuItem<T>(
            value: item,
            child: itemBuilder(item),
          )).toList(),
          onChanged: onChanged,
          hint: Text(
            hint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.tealAccent,
          ),
          dropdownColor: AppTheme.darkGray,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightGray,
          ),
        ),
      ),
    );
  }

  Widget _buildAlgorithmItem(EncryptionAlgorithm algorithm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          algorithm.displayName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          algorithm.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildKeySizeItem(int keySize) {
    return Row(
      children: [
        Text(
          '$keySize bits',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            // Info: Replaced deprecated 'withOpacity'
            color: _getKeySizeColor(keySize).withAlpha((255 * 0.2).round()),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getKeySizeLabel(keySize),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getKeySizeColor(keySize),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeItem(OperationMode mode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          mode.displayName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          mode.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getKeySizeColor(int keySize) {
    if (keySize >= 256) return AppTheme.limeGreen;
    if (keySize >= 192) return AppTheme.cyanAccent;
    if (keySize >= 128) return AppTheme.warningAmber;
    return AppTheme.errorRed;
  }

  String _getKeySizeLabel(int keySize) {
    if (keySize >= 256) return 'HIGH';
    if (keySize >= 192) return 'MEDIUM';
    if (keySize >= 128) return 'BASIC';
    return 'LOW';
  }

  String _getSecurityLevel() {
    final keySize = widget.config.keySize;
    final isAead = widget.config.mode == OperationMode.gcm;
    
    if (keySize >= 256 && isAead) return 'MAXIMUM';
    if (keySize >= 256 || isAead) return 'HIGH';
    if (keySize >= 192) return 'MEDIUM';
    return 'BASIC';
  }
}