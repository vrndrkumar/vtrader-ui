import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTradePage extends ConsumerWidget {
  final String? tradeId;

  const AddTradePage({super.key, this.tradeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tradeId != null ? 'Edit Trade' : 'Add Trade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${tradeId != null ? 'Edit' : 'Add'} Trade Page - Coming Soon'),
            if (tradeId != null) ...[
              const SizedBox(height: 16),
              Text('Trade ID: $tradeId'),
            ],
          ],
        ),
      ),
    );
  }
}

