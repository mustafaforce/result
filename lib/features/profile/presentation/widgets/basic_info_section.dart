import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';

class BasicInfoSection extends StatelessWidget {
  const BasicInfoSection({
    super.key,
    required this.fullNameController,
    required this.departmentController,
    required this.yearController,
    required this.onFullNameChanged,
  });

  final TextEditingController fullNameController;
  final TextEditingController departmentController;
  final TextEditingController yearController;
  final VoidCallback onFullNameChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Basic Information',
              style: GoogleFonts.manrope(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if ((value ?? '').trim().length < 2) {
                  return 'Enter valid full name';
                }
                return null;
              },
              onChanged: (_) => onFullNameChanged(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: departmentController,
              decoration: const InputDecoration(
                labelText: 'Department',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Academic Year',
                prefixIcon: Icon(Icons.calendar_month_outlined),
              ),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isEmpty) {
                  return null;
                }

                final year = int.tryParse(text);
                if (year == null) {
                  return 'Academic year must be number';
                }

                if (year < 1 || year > 8) {
                  return 'Academic year must be between 1 and 8';
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
