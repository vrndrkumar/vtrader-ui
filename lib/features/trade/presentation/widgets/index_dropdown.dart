import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/index_model.dart';
import '../../../../shared/providers/master_data_provider.dart';

class IndexDropdown extends ConsumerWidget {
  final String? label;
  final String? hint;
  final ValueChanged<IndexModel?>? onChanged;
  final IndexModel? value;
  final bool enabled;

  const IndexDropdown({
    super.key,
    this.label,
    this.hint,
    this.onChanged,
    this.value,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterDataState = ref.watch(masterDataStateProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
            color: enabled 
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.surface.withOpacity(0.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<IndexModel>(
              value: value ?? selectedIndex,
              onChanged: enabled ? (IndexModel? newValue) {
                if (newValue != null) {
                  ref.read(selectedIndexProvider.notifier).state = newValue;
                  // Clear selected expiry when index changes
                  ref.read(selectedExpiryProvider.notifier).state = null;
                  onChanged?.call(newValue);
                }
              } : null,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hint: masterDataState.isLoading
                  ? Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading indices...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    )
                  : masterDataState.hasError
                      ? Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Failed to load indices',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          hint ?? 'Select Index',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
              items: masterDataState.indices.map((IndexModel index) {
                return DropdownMenuItem<IndexModel>(
                  value: index,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getIndexColor(index.symbolCode),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              index.symbolName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${index.symbolCode} • ${index.exchange}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
        if (masterDataState.hasError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Using mock data. Check your internet connection.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getIndexColor(String symbolCode) {
    switch (symbolCode) {
      case 'NIFTY':
        return Colors.blue;
      case 'BANKNIFTY':
        return Colors.green;
      case 'FINNIFTY':
        return Colors.orange;
      case 'BANKEX':
        return Colors.purple;
      case 'SENSEX':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
