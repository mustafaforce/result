import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/seat.dart';
import '../../domain/usecases/delete_seat.dart';
import '../../domain/usecases/get_my_seats.dart';
import '../../domain/usecases/update_seat.dart';

class MySeatsPage extends StatefulWidget {
  const MySeatsPage({
    super.key,
    required this.getMySeats,
    required this.deleteSeat,
    required this.updateSeat,
  });

  final GetMySeats getMySeats;
  final DeleteSeat deleteSeat;
  final UpdateSeat updateSeat;

  @override
  State<MySeatsPage> createState() => _MySeatsPageState();
}

class _MySeatsPageState extends State<MySeatsPage> {
  List<Seat> _seats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final seats = await widget.getMySeats();
      if (!mounted) return;
      setState(() {
        _seats = seats;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleAvailability(Seat seat) async {
    final updated = Seat(
      id: seat.id,
      ownerId: seat.ownerId,
      title: seat.title,
      description: seat.description,
      hallName: seat.hallName,
      seatNumber: seat.seatNumber,
      location: seat.location,
      monthlyFee: seat.monthlyFee,
      isAvailable: !seat.isAvailable,
      facilities: seat.facilities,
    );
    try {
      await widget.updateSeat(updated);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update seat')),
      );
    }
  }

  Future<void> _deleteSeat(String seatId) async {
    try {
      await widget.deleteSeat(seatId);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete seat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Seats')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _seats.isEmpty
              ? _emptyState()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _seats.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _seatCard(_seats[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRoutes.seatForm);
          _load();
        },
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.nearBlack,
        child: const Icon(Icons.add_rounded),
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
            Icon(Icons.event_seat_rounded,
                color: AppColors.silver, size: 56),
            const SizedBox(height: 16),
            Text(
              'No seat listings',
              style: GoogleFonts.manrope(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first hall or mess seat.',
              style: GoogleFonts.manrope(
                color: AppColors.silver,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatCard(Seat seat) {
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
                Expanded(
                  child: Text(
                    seat.title,
                    style: GoogleFonts.manrope(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _deleteSeat(seat.id),
                  child: Icon(Icons.delete_outline_rounded,
                      color: AppColors.negativeRed, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${seat.hallName}${seat.seatNumber != null ? ' · Seat ${seat.seatNumber}' : ''}',
              style: GoogleFonts.manrope(
                color: AppColors.silver,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            if (seat.monthlyFee != null) ...[
              const SizedBox(height: 2),
              Text(
                'BDT ${seat.monthlyFee!.toStringAsFixed(0)}/mo',
                style: GoogleFonts.manrope(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _toggleAvailability(seat),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: seat.isAvailable
                          ? AppColors.green.withValues(alpha: 0.15)
                          : AppColors.negativeRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      seat.isAvailable ? 'Available' : 'Unavailable',
                      style: GoogleFonts.manrope(
                        color:
                            seat.isAvailable ? AppColors.green : AppColors.negativeRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).pushNamed(
                      AppRoutes.seatForm,
                      arguments: seat,
                    );
                    _load();
                  },
                  child: Icon(Icons.edit_outlined,
                      color: AppColors.silver, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
