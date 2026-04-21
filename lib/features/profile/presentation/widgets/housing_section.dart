import 'package:flutter/material.dart';

class HousingSection extends StatelessWidget {
  const HousingSection({
    super.key,
    required this.budgetController,
    required this.bioController,
  });

  final TextEditingController budgetController;
  final TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Housing Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monthly Budget (BDT)',
                prefixIcon: Icon(Icons.wallet_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio / Notes',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
