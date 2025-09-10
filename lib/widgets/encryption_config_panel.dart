import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/encryption_config.dart';
import '../services/app_state.dart';
import '../theme.dart';

class EncryptionConfigPanel extends ConsumerWidget {
  const EncryptionConfigPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAlgorithm = ref.watch(selectedAlgorithmProvider);
    final availableKeyLengths = ref.watch(availableKeyLengthsProvider);
    final availableModes = ref.watch(availableModesProvider);
    final selectedKeyLength = ref.watch(selectedKeyLengthProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final password = ref.watch(passwordProvider);
    final passwordVisible = ref.watch(passwordVisibilityProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encryption Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Algorithm Selection
            _buildDropdownField(
              context: context,
              label: 'Algorithm',
              value: selectedAlgorithm,
              items: CryptoAlgorithm.supportedAlgorithms
                  .map((algo) => algo.name)
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(selectedAlgorithmProvider.notifier).state = value;
                  
                  // Update key length and mode when algorithm changes
                  final newAvailableKeyLengths = ref.read(availableKeyLengthsProvider);
                  final newAvailableModes = ref.read(availableModesProvider);
                  
                  if (newAvailableKeyLengths.isNotEmpty) {
                    ref.read(selectedKeyLengthProvider.notifier).state = 
                        newAvailableKeyLengths.last;
                  }
                  
                  if (newAvailableModes.isNotEmpty) {
                    ref.read(selectedModeProvider.notifier).state = 
                        newAvailableModes.first;
                  }
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                // Key Length Selection
                Expanded(
                  child: _buildDropdownField(
                    context: context,
                    label: 'Key Length (bits)',
                    value: selectedKeyLength.toString(),
                    items: availableKeyLengths.map((length) => length.toString()).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedKeyLengthProvider.notifier).state = 
                            int.parse(value);
                      }
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Mode Selection
                Expanded(
                  child: _buildDropdownField(
                    context: context,
                    label: 'Mode',
                    value: selectedMode,
                    items: availableModes,
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedModeProvider.notifier).state = value;
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Password Input
            TextFormField(
              initialValue: password,
              obscureText: !passwordVisible,
              onChanged: (value) {
                ref.read(passwordProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter encryption password',
                prefixIcon: Icon(
                  Icons.key,
                  color: AppTheme.primaryAccent,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.lightGrey,
                  ),
                  onPressed: () {
                    ref.read(passwordVisibilityProvider.notifier).state = 
                        !passwordVisible;
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.darkGrey,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: const Color(0xFF1A1A1A),
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.primaryAccent,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}