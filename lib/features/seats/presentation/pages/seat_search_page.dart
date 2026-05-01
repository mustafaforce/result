import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../matching/domain/services/compatibility_scorer.dart';
import '../../../matching/domain/entities/matching_preference.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../../seats_applications/domain/usecases/apply_for_seat.dart';
import '../../domain/entities/seat.dart';
import '../../domain/usecases/get_available_seats.dart';
import '../../domain/usecases/get_occupants.dart';

class SeatSearchPage extends StatefulWidget {
  const SeatSearchPage({
    super.key,
    required this.getAvailableSeats,
    required this.applyForSeat,
    required this.getOccupants,
  });

  final GetAvailableSeats getAvailableSeats;
  final ApplyForSeat applyForSeat;
  final GetOccupants getOccupants;

  @override
  State<SeatSearchPage> createState() => _SeatSearchPageState();
}

class _SeatSearchPageState extends State<SeatSearchPage> {
  final _searchController = TextEditingController();
  final _appliedSeatIds = <String>{};
  List<Seat> _allSeats = [];
  List<Seat> _filteredSeats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final seats = await widget.getAvailableSeats();
      if (!mounted) return;
      setState(() {
        _allSeats = seats;
        _filteredSeats = seats;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _filter(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _filteredSeats = _allSeats.where((s) {
        if (q.isEmpty) return true;
        return s.title.toLowerCase().contains(q) ||
            s.hallName.toLowerCase().contains(q) ||
            (s.location?.toLowerCase().contains(q) ?? false) ||
            (s.seatNumber?.toLowerCase().contains(q) ?? false);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Seats'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.applications),
            icon: const Icon(Icons.assignment_rounded),
            tooltip: 'My Applications',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by hall, location, seat...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _filter('');
                        },
                      )
                    : null,
              ),
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSeats.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: _filteredSeats.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _seatCard(_filteredSeats[index]),
                        ),
                      ),
          ),
        ],
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
            Icon(Icons.search_off_rounded,
                color: AppColors.silver, size: 56),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No seats match your search'
                  : 'No seats available',
              style: GoogleFonts.manrope(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _apply(String seatId) async {
    try {
      await widget.applyForSeat(seatId: seatId);
      if (!mounted) return;
      setState(() => _appliedSeatIds.add(seatId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted!')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to apply')),
      );
    }
  }

  Future<void> _showOccupants(Seat seat) async {
    try {
      final occupants = await widget.getOccupants.call(seat.id);
      if (!mounted) return;

      final uid = SupabaseService.client.auth.currentUser?.id;
      if (uid == null) return;

      final client = SupabaseService.client;

      final myProfileJson = await client
          .from('profiles')
          .select('*, user_preferences (*), matching_preferences (*)')
          .eq('id', uid)
          .maybeSingle();

      if (myProfileJson == null) return;

      final myPrefsJson =
          myProfileJson['matching_preferences'] as Map<String, dynamic>?;
      final myUserPrefs =
          myProfileJson['user_preferences'] as Map<String, dynamic>?;

      final myProfile = UserProfile(
        fullName: (myProfileJson['full_name'] as String?) ?? '',
        isSmoker: (myUserPrefs?['is_smoker'] as bool?) ?? false,
        isNightOwl: (myUserPrefs?['is_night_owl'] as bool?) ?? false,
        cleanlinessLevel: (myUserPrefs?['cleanliness_level'] as int?) ?? 3,
        academicYear: myProfileJson['academic_year'] as int?,
      );

      final myPrefs = MatchingPreference(
        studyHabit: (myPrefsJson?['study_habit'] as String?) ?? 'moderate',
        guestFrequency:
            (myPrefsJson?['guest_frequency'] as String?) ?? 'occasional',
        noiseTolerance: (myPrefsJson?['noise_tolerance'] as num?)?.toInt() ?? 3,
        sleepTime: (myPrefsJson?['sleep_time'] as String?) ?? 'flexible',
        sharingPreference:
            (myPrefsJson?['sharing_preference'] as String?) ?? 'flexible',
      );

      final occupantIds = occupants
          .map((o) => o['applicant_id'] as String)
          .where((id) => id.isNotEmpty)
          .toList();

      final userPrefsMap =
          await widget.getOccupants.callUserPrefs(occupantIds);
      final matchingPrefsMap =
          await widget.getOccupants.callMatchingPrefs(occupantIds);

      final scorer = CompatibilityScorer();

      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Occupants (${seat.occupantCount}/${seat.capacity})',
                  style: GoogleFonts.manrope(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              const SizedBox(height: 12),
              if (occupants.isEmpty)
                Text('No occupants yet',
                    style: GoogleFonts.manrope(
                        color: AppColors.silver, fontSize: 14))
              else
                ...occupants.map((o) {
                  final oid = o['applicant_id'] as String;
                  final p =
                      o['applicant_profile'] as Map<String, dynamic>?;
                  final name = p?['full_name'] as String? ?? 'Unknown';
                  final dept = p?['department'] as String? ?? '';

                  final up = userPrefsMap[oid];
                  final mp = matchingPrefsMap[oid];

                  final theirProfile = UserProfile(
                    fullName: name,
                    isSmoker: (up?['is_smoker'] as bool?) ?? false,
                    isNightOwl: (up?['is_night_owl'] as bool?) ?? false,
                    cleanlinessLevel:
                        (up?['cleanliness_level'] as num?)?.toInt() ?? 3,
                    academicYear: p?['academic_year'] as int?,
                  );

                  final theirPrefs = MatchingPreference(
                    studyHabit:
                        (mp?['study_habit'] as String?) ?? 'moderate',
                    guestFrequency: (mp?['guest_frequency'] as String?) ??
                        'occasional',
                    noiseTolerance:
                        (mp?['noise_tolerance'] as num?)?.toInt() ?? 3,
                    sleepTime:
                        (mp?['sleep_time'] as String?) ?? 'flexible',
                    sharingPreference: (mp?['sharing_preference']
                            as String?) ??
                        'flexible',
                  );

                  final score = scorer.score(
                    myProfile: myProfile,
                    myPreferences: myPrefs,
                    theirProfile: theirProfile,
                    theirPreferences: theirPrefs,
                  );

                  final scoreColor = score >= 75
                      ? AppColors.green
                      : score >= 50
                          ? AppColors.warningOrange
                          : AppColors.silver;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.midDark,
                        child: Text(name[0].toUpperCase(),
                            style: GoogleFonts.manrope(
                                color: AppColors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: GoogleFonts.manrope(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                            if (dept.isNotEmpty)
                              Text(dept,
                                  style: GoogleFonts.manrope(
                                      color: AppColors.silver,
                                      fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: scoreColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${score.round()}%',
                            style: GoogleFonts.manrope(
                                color: scoreColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ),
                    ]),
                  );
                }),
            ],
          ),
        ),
      );
    } catch (_) {}
  }

  Widget _seatCard(Seat seat) {
    final alreadyApplied = _appliedSeatIds.contains(seat.id);
    final filled = seat.occupantCount;
    final remaining = seat.capacity - filled;
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.midDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.event_seat_rounded,
                      color: AppColors.green, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seat.title,
                        style: GoogleFonts.manrope(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        seat.hallName,
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
            if (seat.seatNumber != null || seat.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (seat.seatNumber != null) ...[
                    Icon(Icons.tag_rounded,
                        size: 14, color: AppColors.silver),
                    const SizedBox(width: 4),
                    Text(
                      'Seat ${seat.seatNumber}',
                      style: GoogleFonts.manrope(
                        color: AppColors.silver,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    if (seat.location != null) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.silver),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          seat.location!,
                          style: GoogleFonts.manrope(
                            color: AppColors.silver,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
            if (seat.monthlyFee != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'BDT ${seat.monthlyFee!.toStringAsFixed(0)}/mo',
                    style: GoogleFonts.manrope(
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showOccupants(seat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: remaining > 0
                            ? AppColors.green.withValues(alpha: 0.15)
                            : AppColors.negativeRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$filled/${seat.capacity} filled',
                        style: GoogleFonts.manrope(
                          color: remaining > 0
                              ? AppColors.green
                              : AppColors.negativeRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: alreadyApplied
                    ? null
                    : () => _apply(seat.id),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: alreadyApplied
                      ? AppColors.midDark
                      : AppColors.green,
                  foregroundColor: alreadyApplied
                      ? AppColors.silver
                      : AppColors.nearBlack,
                ),
                child: Text(alreadyApplied
                    ? 'APPLIED'
                    : 'APPLY FOR SEAT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
