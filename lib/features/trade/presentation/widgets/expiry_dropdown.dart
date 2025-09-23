import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/master_data_provider.dart';

class ExpiryDropdown extends ConsumerWidget {
  final String? label;
  final String? hint;
  final ValueChanged<String?>? onChanged;
  final String? value;
  final bool enabled;

  const ExpiryDropdown({
    super.key,
    this.label,
    this.hint,
    this.onChanged,
    this.value,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final availableExpiries = ref.watch(availableExpiriesProvider);
    final selectedExpiry = ref.watch(selectedExpiryProvider);

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
            child: DropdownButton<String>(
              value: value ?? selectedExpiry,
              onChanged: enabled && selectedIndex != null ? (String? newValue) {
                ref.read(selectedExpiryProvider.notifier).state = newValue;
                onChanged?.call(newValue);
              } : null,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hint: selectedIndex == null
                  ? Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select an index first',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    )
                  : availableExpiries.isEmpty
                      ? Row(
                          children: [
                            Icon(
                              Icons.warning_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'No expiry dates available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          hint ?? 'Select Expiry',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
              items: availableExpiries.map((String expiry) {
                return DropdownMenuItem<String>(
                  value: expiry,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getExpiryColor(expiry),
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
                              _formatExpiryForDisplay(expiry),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              _getExpiryDescription(expiry),
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
        if (selectedIndex != null && availableExpiries.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${availableExpiries.length} expiry date${availableExpiries.length > 1 ? 's' : ''} available for ${selectedIndex.symbolName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getExpiryColor(String expiry) {
    // Color based on how close the expiry is
    final now = DateTime.now();
    final expiryDate = _parseExpiryDate(expiry);
    
    if (expiryDate == null) return Colors.grey;
    
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    
    if (daysUntilExpiry <= 7) {
      return Colors.red; // Near expiry
    } else if (daysUntilExpiry <= 30) {
      return Colors.orange; // Medium term
    } else {
      return Colors.green; // Long term
    }
  }

  String _formatExpiryForDisplay(String expiry) {
    // Convert "23SEP25" to "23 Sep 2025"
    try {
      final day = expiry.substring(0, 2);
      final monthStr = expiry.substring(2, 5);
      final year = '20${expiry.substring(5, 7)}';
      
      final monthMap = {
        'JAN': 'Jan', 'FEB': 'Feb', 'MAR': 'Mar', 'APR': 'Apr',
        'MAY': 'May', 'JUN': 'Jun', 'JUL': 'Jul', 'AUG': 'Aug',
        'SEP': 'Sep', 'OCT': 'Oct', 'NOV': 'Nov', 'DEC': 'Dec',
      };
      
      final month = monthMap[monthStr] ?? monthStr;
      return '$day $month $year';
    } catch (e) {
      return expiry;
    }
  }

  String _getExpiryDescription(String expiry) {
    final expiryDate = _parseExpiryDate(expiry);
    if (expiryDate == null) return 'Invalid date';
    
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;
    
    if (daysUntilExpiry < 0) {
      return 'Expired';
    } else if (daysUntilExpiry == 0) {
      return 'Expires today';
    } else if (daysUntilExpiry == 1) {
      return 'Expires tomorrow';
    } else if (daysUntilExpiry <= 7) {
      return '$daysUntilExpiry days to expiry';
    } else if (daysUntilExpiry <= 30) {
      return '${(daysUntilExpiry / 7).round()} weeks to expiry';
    } else {
      return '${(daysUntilExpiry / 30).round()} months to expiry';
    }
  }

  DateTime? _parseExpiryDate(String expiry) {
    try {
      final day = int.parse(expiry.substring(0, 2));
      final monthStr = expiry.substring(2, 5);
      final year = 2000 + int.parse(expiry.substring(5, 7));
      
      final monthMap = {
        'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
        'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
      };
      
      final month = monthMap[monthStr] ?? 1;
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
