import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBrokerPage extends ConsumerWidget {
  final String? brokerId;

  const AddBrokerPage({super.key, this.brokerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brokerId != null ? 'Edit Broker' : 'Add Broker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${brokerId != null ? 'Edit' : 'Add'} Broker Page - Coming Soon'),
            if (brokerId != null) ...[
              const SizedBox(height: 16),
              Text('Broker ID: $brokerId'),
            ],
          ],
        ),
      ),
    );
  }
}

