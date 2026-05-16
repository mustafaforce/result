import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class AdminFreeSpotsPage extends StatefulWidget {
  const AdminFreeSpotsPage({
    super.key,
    required this.adminRemoteDataSource,
  });

  final AdminRemoteDataSource adminRemoteDataSource;

  @override
  State<AdminFreeSpotsPage> createState() => _AdminFreeSpotsPageState();
}

class _AdminFreeSpotsPageState extends State<AdminFreeSpotsPage> {
  List<Map<String, dynamic>> _rows = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final rows = await widget.adminRemoteDataSource.getPerSeatCapacity();
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalFree = _rows.fold<int>(
      0,
      (sum, r) => sum + ((r['free'] as int?) ?? 0),
    );
    final totalCapacity = _rows.fold<int>(
      0,
      (sum, r) => sum + ((r['capacity'] as int?) ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Spots'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.airline_seat_recline_normal_rounded,
                            color: AppColors.green, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Total free across all rooms',
                            style: GoogleFonts.manrope(
                              color: AppColors.silver,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '$totalFree / $totalCapacity',
                          style: GoogleFonts.manrope(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_rows.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'No seats yet',
                          style: GoogleFonts.manrope(
                            color: AppColors.silver,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._rows.map(_card),
                ],
              ),
            ),
    );
  }

  Widget _card(Map<String, dynamic> r) {
    final title = r['title'] as String? ?? 'Untitled';
    final hall = r['hall_name'] as String? ?? '';
    final seatNumber = r['seat_number'] as String?;
    final capacity = r['capacity'] as int? ?? 0;
    final occupied = r['occupied'] as int? ?? 0;
    final free = r['free'] as int? ?? 0;

    final isFull = free <= 0;
    final color = isFull ? AppColors.negativeRed : AppColors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
        ),
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
                      color: AppColors.green, size: 22),
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
                      const SizedBox(height: 2),
                      Text(
                        seatNumber == null
                            ? hall
                            : '$hall · Seat $seatNumber',
                        style: GoogleFonts.manrope(
                          color: AppColors.silver,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Text(
                    isFull ? 'FULL' : '$free FREE',
                    style: GoogleFonts.manrope(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _miniStat('Capacity', '$capacity', AppColors.announcementBlue),
                const SizedBox(width: 10),
                _miniStat('Occupied', '$occupied', AppColors.warningOrange),
                const SizedBox(width: 10),
                _miniStat('Free', '$free', color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.midDark,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                color: AppColors.silver,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.manrope(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
