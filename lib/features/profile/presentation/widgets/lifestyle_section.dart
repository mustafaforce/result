import 'package:flutter/material.dart';

class LifestyleSection extends StatelessWidget {
  const LifestyleSection({
    super.key,
    required this.isSmoker,
    required this.isNightOwl,
    required this.cleanliness,
    required this.onSmokerChanged,
    required this.onNightOwlChanged,
    required this.onCleanlinessChanged,
  });

  final bool isSmoker;
  final bool isNightOwl;
  final int cleanliness;
  final ValueChanged<bool> onSmokerChanged;
  final ValueChanged<bool> onNightOwlChanged;
  final ValueChanged<double> onCleanlinessChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Lifestyle Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Smoker'),
              value: isSmoker,
              onChanged: onSmokerChanged,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Night Owl'),
              value: isNightOwl,
              onChanged: onNightOwlChanged,
            ),
            const SizedBox(height: 8),
            Text(
              'Cleanliness Level: $cleanliness / 5',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              label: cleanliness.toString(),
              value: cleanliness.toDouble(),
              onChanged: onCleanlinessChanged,
            ),
          ],
        ),
      ),
    );
  }
}
