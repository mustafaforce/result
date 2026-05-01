import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../requests/domain/usecases/get_my_requests.dart';
import '../../../requests/domain/usecases/send_roommate_request.dart';
import '../../domain/entities/match_candidate.dart';
import '../../domain/usecases/get_match_suggestions.dart';

class MatchResultsPage extends StatefulWidget {
  const MatchResultsPage({
    super.key,
    required this.getMatchSuggestions,
    required this.sendRoommateRequest,
    required this.getMyRequests,
  });

  final GetMatchSuggestions getMatchSuggestions;
  final SendRoommateRequest sendRoommateRequest;
  final GetMyRequests getMyRequests;

  @override
  State<MatchResultsPage> createState() => _MatchResultsPageState();
}

class _MatchResultsPageState extends State<MatchResultsPage> {
  final _matches = <MatchCandidate>[];
  final _sentUserIds = <String>{};
  final _receivedFromUserIds = <String>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);

    try {
      final results = await widget.getMatchSuggestions();
      final sent = await widget.getMyRequests.sent();
      final received = await widget.getMyRequests.received();

      if (!mounted) return;

      setState(() {
        _matches
          ..clear()
          ..addAll(results);
        _sentUserIds
          ..clear()
          ..addAll(sent.map((r) => r.toUserId));
        _receivedFromUserIds
          ..clear()
          ..addAll(received
              .where((r) => r.isPending)
              .map((r) => r.fromUserId));
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendRequest(String userId) async {
    try {
      await widget.sendRoommateRequest(toUserId: userId);
      if (!mounted) return;
      setState(() => _sentUserIds.add(userId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Roommate request sent!')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Suggestions'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.requests),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'My Requests',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _matches.isEmpty
              ? _emptyState()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _matches.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final match = _matches[index];
                      return _matchCard(match);
                    },
                  ),
                ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded,
                color: AppColors.silver, size: 56),
            const SizedBox(height: 16),
            Text(
              'No matches found',
              style: GoogleFonts.manrope(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your profile preferences\nto get roommate suggestions.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: AppColors.silver,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _load,
              child: const Text('REFRESH'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _matchCard(MatchCandidate match) {
    final score = match.score ?? 0;
    final initials = match.fullName.isNotEmpty
        ? match.fullName[0].toUpperCase()
        : '?';
    final year = match.academicYear?.toString() ?? '—';
    final dept = match.department ?? '—';
    final alreadySent = _sentUserIds.contains(match.userId);
    final receivedFrom = _receivedFromUserIds.contains(match.userId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.midDark,
                  child: Text(
                    initials,
                    style: GoogleFonts.manrope(
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              match.fullName,
                              style: GoogleFonts.manrope(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          _scoreBadge(score),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dept · Year $year',
                        style: GoogleFonts.manrope(
                          color: AppColors.silver,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: AppColors.midDark,
                color: score >= 75
                    ? AppColors.green
                    : score >= 50
                        ? AppColors.warningOrange
                        : AppColors.silver,
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 12),
            if (receivedFrom) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.midDark,
                  borderRadius: BorderRadius.circular(500),
                ),
                child: Text(
                  'REQUEST RECEIVED',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: AppColors.warningOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ] else if (alreadySent) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.midDark,
                  borderRadius: BorderRadius.circular(500),
                ),
                child: Text(
                  'REQUEST SENT',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: AppColors.silver,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _sendRequest(match.userId),
                  child: const Text('SEND REQUEST'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _scoreBadge(double score) {
    final color = score >= 75
        ? AppColors.green
        : score >= 50
            ? AppColors.warningOrange
            : AppColors.silver;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${score.round()}%',
        style: GoogleFonts.manrope(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
