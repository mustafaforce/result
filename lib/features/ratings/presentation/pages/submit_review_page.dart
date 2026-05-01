import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/usecases/submit_rating.dart';

class SubmitReviewPage extends StatefulWidget {
  const SubmitReviewPage({
    super.key,
    required this.revieweeId,
    required this.revieweeName,
    required this.submitRating,
  });

  final String revieweeId;
  final String revieweeName;
  final SubmitRating submitRating;

  @override
  State<SubmitReviewPage> createState() => _SubmitReviewPageState();
}

class _SubmitReviewPageState extends State<SubmitReviewPage> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a rating')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.submitRating(
        revieweeId: widget.revieweeId,
        rating: _rating,
        reviewText: _reviewController.text.trim().isNotEmpty
            ? _reviewController.text.trim()
            : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted!')),
      );
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit review')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Roommate')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.midDark,
                child: Text(
                  widget.revieweeName.isNotEmpty
                      ? widget.revieweeName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.manrope(
                    color: AppColors.green,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.revieweeName,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: filled ? AppColors.warningOrange : AppColors.borderGray,
                        size: 40,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                _rating > 0 ? '$_rating / 5' : 'Tap to rate',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: AppColors.silver,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Write a review (optional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                child: Text(_isSaving ? 'SUBMITTING...' : 'SUBMIT REVIEW'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
