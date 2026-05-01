import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';

class MatchingPrefsSection extends StatelessWidget {
  const MatchingPrefsSection({
    super.key,
    required this.studyHabit,
    required this.guestFrequency,
    required this.noiseTolerance,
    required this.sleepTime,
    required this.sharingPreference,
    required this.onStudyHabitChanged,
    required this.onGuestFrequencyChanged,
    required this.onNoiseToleranceChanged,
    required this.onSleepTimeChanged,
    required this.onSharingPreferenceChanged,
  });

  final String studyHabit;
  final String guestFrequency;
  final int noiseTolerance;
  final String sleepTime;
  final String sharingPreference;
  final ValueChanged<String> onStudyHabitChanged;
  final ValueChanged<String> onGuestFrequencyChanged;
  final ValueChanged<double> onNoiseToleranceChanged;
  final ValueChanged<String> onSleepTimeChanged;
  final ValueChanged<String> onSharingPreferenceChanged;

  static const _studyOptions = ['quiet', 'moderate', 'social'];
  static const _guestOptions = ['never', 'occasional', 'frequent'];
  static const _sleepOptions = ['early_bird', 'flexible', 'night_owl'];
  static const _shareOptions = ['private', 'flexible', 'okay_shared'];

  static const _labels = {
    'quiet': 'Quiet',
    'moderate': 'Moderate',
    'social': 'Social',
    'never': 'Never',
    'occasional': 'Occasional',
    'frequent': 'Frequent',
    'early_bird': 'Early Bird',
    'flexible': 'Flexible',
    'night_owl': 'Night Owl',
    'private': 'Private Room',
    'okay_shared': 'Okay Sharing',
  };

  String _label(String key) => _labels[key] ?? key;

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              color: AppColors.silver,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.midDark,
              borderRadius: BorderRadius.circular(500),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: AppColors.midDark,
                icon: const Icon(Icons.expand_more_rounded,
                    color: AppColors.silver),
                style: GoogleFonts.manrope(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                items: options.map((o) {
                  return DropdownMenuItem(
                    value: o,
                    child: Text(_label(o)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Matching Preferences',
              style: GoogleFonts.manrope(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _dropdown(
              label: 'Study Habit',
              value: studyHabit,
              options: _studyOptions,
              onChanged: (v) {
                if (v != null) onStudyHabitChanged(v);
              },
            ),
            _dropdown(
              label: 'Guest Frequency',
              value: guestFrequency,
              options: _guestOptions,
              onChanged: (v) {
                if (v != null) onGuestFrequencyChanged(v);
              },
            ),
            _dropdown(
              label: 'Sleep Time',
              value: sleepTime,
              options: _sleepOptions,
              onChanged: (v) {
                if (v != null) onSleepTimeChanged(v);
              },
            ),
            _dropdown(
              label: 'Sharing Preference',
              value: sharingPreference,
              options: _shareOptions,
              onChanged: (v) {
                if (v != null) onSharingPreferenceChanged(v);
              },
            ),
            const SizedBox(height: 4),
            Text(
              'Noise Tolerance: $noiseTolerance / 5',
              style: GoogleFonts.manrope(
                color: AppColors.silver,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              label: noiseTolerance.toString(),
              value: noiseTolerance.toDouble(),
              onChanged: onNoiseToleranceChanged,
            ),
          ],
        ),
      ),
    );
  }
}
