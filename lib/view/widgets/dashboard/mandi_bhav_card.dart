import 'package:flutter/material.dart';

class MandiBhavCard extends StatelessWidget {
  final List<Map<String, String>> mandiData;
  const MandiBhavCard({required this.mandiData, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF6ED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MANDI BHAV', style: Theme.of(context).textTheme.titleMedium),
                TextButton(onPressed: () {}, child: const Text('View all')),
              ],
            ),
            ...mandiData.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(child: Text(item['name']!, style: Theme.of(context).textTheme.bodyMedium)),
                  Text(item['price']!, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 8),
                  Text(item['change']!, style: TextStyle(color: Colors.green)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
} 