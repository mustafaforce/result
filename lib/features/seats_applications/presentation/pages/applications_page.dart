import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
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
  late final TabController _tabController;
  final _mine = <SeatApplication>[];
  final _forMySeats = <SeatApplication>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final mine = await widget.getApplications.mine();
      final forMySeats = await widget.getApplications.forMySeats();
      if (!mounted) return;
      setState(() {
        _mine
          ..clear()
          ..addAll(mine);
        _forMySeats
          ..clear()
          ..addAll(forMySeats);
        _isLoading = false;
      });
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
        title: const Text('Applications'),
        bottom: TabBar(
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
            Tab(text: 'MY APPS (${_mine.length})'),
            Tab(text: 'RECEIVED (${_forMySeats.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _list(_mine, isOwner: false),
                _list(_forMySeats, isOwner: true),
              ],
            ),
    );
  }

  Widget _list(List<SeatApplication> apps, {required bool isOwner}) {
    if (apps.isEmpty) {
      return Center(
        child: Text(
          isOwner ? 'No applications received' : 'No applications yet',
          style: GoogleFonts.manrope(
            color: AppColors.silver,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: apps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _card(apps[i], isOwner),
    );
  }

  Widget _card(SeatApplication app, bool isOwner) {
    final title = isOwner
        ? (app.applicantName ?? 'Unknown')
        : (app.seatTitle ?? 'Unknown');

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
                  child: Icon(
                    isOwner ? Icons.person_rounded : Icons.event_seat_rounded,
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
                        title,
                        style: GoogleFonts.manrope(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (app.seatTitle != null && isOwner) ...[
                        const SizedBox(height: 2),
                        Text(
                          app.seatTitle!,
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
            if (isOwner && app.isPending) ...[
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
