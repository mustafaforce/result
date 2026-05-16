import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/admin.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/seat_application.dart';
import '../../domain/usecases/get_applications.dart';
import '../../domain/usecases/respond_to_application.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({
    super.key,
    required this.getApplications,
    required this.respondToApplication,
  });

  final GetApplications getApplications;
  final RespondToApplication respondToApplication;

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _mine = <SeatApplication>[];
  final _adminAll = <SeatApplication>[];
  bool _isLoading = true;
  late final bool _isAdmin;

  @override
  void initState() {
    super.initState();
    final email = SupabaseService.client.auth.currentUser?.email;
    _isAdmin = AdminConstants.isAdmin(email);
    _tabController = TabController(
      length: _isAdmin ? 2 : 1,
      vsync: this,
    );
    _load();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      if (_isAdmin) {
        final pending = await widget.getApplications.all(pendingOnly: true);
        final all = await widget.getApplications.all();
        if (!mounted) return;
        setState(() {
          _mine
            ..clear()
            ..addAll(pending);
          _adminAll
            ..clear()
            ..addAll(all);
          _isLoading = false;
        });
      } else {
        final mine = await widget.getApplications.mine();
        if (!mounted) return;
        setState(() {
          _mine
            ..clear()
            ..addAll(mine);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _respond(String appId, bool accept) async {
    try {
      await widget.respondToApplication(applicationId: appId, accept: accept);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to respond')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdmin ? 'Admin · Applications' : 'My Applications'),
        bottom: _isAdmin
            ? TabBar(
                controller: _tabController,
                labelColor: AppColors.green,
                unselectedLabelColor: AppColors.silver,
                indicatorColor: AppColors.green,
                labelStyle: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.4,
                ),
                tabs: [
                  Tab(text: 'PENDING (${_mine.length})'),
                  Tab(text: 'ALL (${_adminAll.length})'),
                ],
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isAdmin
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _list(_mine, adminCanAct: true),
                    _list(_adminAll, adminCanAct: false),
                  ],
                )
              : _list(_mine, adminCanAct: false),
    );
  }

  Widget _list(List<SeatApplication> apps, {required bool adminCanAct}) {
    if (apps.isEmpty) {
      return Center(
        child: Text(
          _isAdmin ? 'No applications' : 'No applications yet',
          style: GoogleFonts.manrope(
            color: AppColors.silver,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: apps.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _card(apps[i], adminCanAct),
      ),
    );
  }

  Widget _card(SeatApplication app, bool adminCanAct) {
    final primary = _isAdmin
        ? (app.applicantName ?? 'Unknown applicant')
        : (app.seatTitle ?? 'Unknown seat');
    final secondary = _isAdmin
        ? (app.seatTitle ?? '')
        : (app.hallName ?? '');

    return GestureDetector(
      onTap: _isAdmin
          ? () => _showApplicantProfile(app.applicantId,
              app.applicantName ?? 'Applicant')
          : null,
      child: Container(
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
                  child: Icon(
                    _isAdmin ? Icons.person_rounded : Icons.event_seat_rounded,
                    color: AppColors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primary,
                        style: GoogleFonts.manrope(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (secondary.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          secondary,
                          style: GoogleFonts.manrope(
                            color: AppColors.silver,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _statusChip(app.status),
              ],
            ),
            if (adminCanAct && app.isPending) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => _respond(app.id, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: Text(
                        'APPROVE',
                        style: GoogleFonts.manrope(
                          color: AppColors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _respond(app.id, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.negativeRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: Text(
                        'REJECT',
                        style: GoogleFonts.manrope(
                          color: AppColors.negativeRed,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }

  Future<void> _showApplicantProfile(String userId, String name) async {
    Map<String, dynamic>? profile;
    try {
      profile = await SupabaseService.client
          .from('profiles')
          .select('*, user_preferences (*), matching_preferences (*)')
          .eq('id', userId)
          .maybeSingle();
    } catch (_) {
      profile = null;
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        if (profile == null) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load profile',
                style: GoogleFonts.manrope(
                    color: AppColors.silver, fontSize: 14)),
          );
        }
        final p = profile;
        final up = p['user_preferences'] as Map<String, dynamic>?;
        final mp = p['matching_preferences'] as Map<String, dynamic>?;
        final fullName = (p['full_name'] as String?) ?? name;
        final department = p['department'] as String?;
        final year = p['academic_year'];
        final budget = p['budget_max'];
        final bio = p['bio'] as String?;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.midDark,
                        child: Text(
                          fullName.isNotEmpty
                              ? fullName[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.manrope(
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fullName,
                                style: GoogleFonts.manrope(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)),
                            if (department != null)
                              Text(department,
                                  style: GoogleFonts.manrope(
                                      color: AppColors.silver,
                                      fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _row('Academic Year',
                      year == null ? '—' : 'Year $year'),
                  _row('Budget',
                      budget == null ? '—' : 'BDT $budget / mo'),
                  if (bio != null && bio.isNotEmpty) _row('Bio', bio),
                  const SizedBox(height: 8),
                  if (up != null) ...[
                    Text('Lifestyle',
                        style: GoogleFonts.manrope(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    const SizedBox(height: 6),
                    _row('Smoker',
                        (up['is_smoker'] as bool? ?? false) ? 'Yes' : 'No'),
                    _row('Night owl',
                        (up['is_night_owl'] as bool? ?? false) ? 'Yes' : 'No'),
                    _row('Cleanliness',
                        '${up['cleanliness_level'] ?? '—'} / 5'),
                  ],
                  if (mp != null) ...[
                    const SizedBox(height: 12),
                    Text('Matching Preferences',
                        style: GoogleFonts.manrope(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    const SizedBox(height: 6),
                    _row('Study habit',
                        (mp['study_habit'] as String?) ?? '—'),
                    _row('Guest frequency',
                        (mp['guest_frequency'] as String?) ?? '—'),
                    _row('Sleep time',
                        (mp['sleep_time'] as String?) ?? '—'),
                    _row('Sharing',
                        (mp['sharing_preference'] as String?) ?? '—'),
                    _row('Noise tolerance',
                        '${mp['noise_tolerance'] ?? '—'} / 5'),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: GoogleFonts.manrope(
                    color: AppColors.silver, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.manrope(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final data = switch (status) {
      'pending' => (AppColors.warningOrange, 'Pending'),
      'approved' => (AppColors.green, 'Approved'),
      'rejected' => (AppColors.negativeRed, 'Rejected'),
      _ => (AppColors.silver, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: data.$1.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        data.$2,
        style: GoogleFonts.manrope(
          color: data.$1,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
