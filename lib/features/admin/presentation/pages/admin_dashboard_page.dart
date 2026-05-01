import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/domain/usecases/get_current_auth_user.dart';
import '../../../auth/domain/usecases/sign_out_user.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({
    super.key,
    required this.signOutUser,
    required this.getCurrentAuthUser,
    required this.adminRemoteDataSource,
  });

  final SignOutUser signOutUser;
  final GetCurrentAuthUser getCurrentAuthUser;
  final AdminRemoteDataSource adminRemoteDataSource;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _totalUsers = 0;
  int _totalSeats = 0;
  int _pendingSeatApps = 0;
  List<Map<String, dynamic>> _recentUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        widget.adminRemoteDataSource.getUserCount(),
        widget.adminRemoteDataSource.getSeatCount(),
        widget.adminRemoteDataSource.getPendingSeatApplications(),
        // widget.adminRemoteDataSource.getPendingRoommateRequests(),
        widget.adminRemoteDataSource.getRecentUsers(),
      ]);
      if (!mounted) return;
      setState(() {
        _totalUsers = results[0] as int;
        _totalSeats = results[1] as int;
        _pendingSeatApps = results[2] as int;
        _recentUsers = results[3] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    try {
      await widget.signOutUser();
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.getCurrentAuthUser();
    final email = user?.email ?? 'adminHall@gmail.com';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.midDark,
                        child: Icon(Icons.shield_rounded,
                            color: AppColors.green, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Admin Panel',
                              style: GoogleFonts.manrope(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          Text(email,
                              style: GoogleFonts.manrope(
                                  color: AppColors.silver,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.silver),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Dashboard',
                  style: GoogleFonts.manrope(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 28)),
              const SizedBox(height: 16),
              if (_isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else ...[
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _statCard('Users', '$_totalUsers', Icons.people_rounded,
                        AppColors.announcementBlue, () {
                      Navigator.of(context).pushNamed(AppRoutes.adminUsers);
                    }),
                    _statCard('Seats', '$_totalSeats', Icons.event_seat_rounded,
                        AppColors.green, () {
                      Navigator.of(context).pushNamed(AppRoutes.mySeats);
                    }),
                    _statCard('Seat Apps', '$_pendingSeatApps',
                        Icons.assignment_rounded, AppColors.warningOrange, () {
                      Navigator.of(context).pushNamed(AppRoutes.applications);
                    }),
                    _statCard('Free Spots', '$_totalSeats',
                        Icons.airline_seat_recline_normal_rounded,
                        AppColors.green, () {
                      Navigator.of(context).pushNamed(AppRoutes.mySeats);
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Recent Users',
                    style: GoogleFonts.manrope(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                const SizedBox(height: 8),
                Expanded(
                  child: _recentUsers.isEmpty
                      ? Center(
                          child: Text('No users yet',
                              style: GoogleFonts.manrope(
                                  color: AppColors.silver, fontSize: 14)))
                      : ListView.separated(
                          itemCount: _recentUsers.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final u = _recentUsers[i];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.darkSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.midDark,
                                    child: Text(
                                      ((u['full_name'] as String?)
                                                  ?.isNotEmpty ==
                                              true
                                          ? (u['full_name'] as String)[0]
                                              .toUpperCase()
                                          : '?'),
                                      style: GoogleFonts.manrope(
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    u['full_name'] as String? ?? 'Unknown',
                                    style: GoogleFonts.manrope(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 22),
            Text(value,
                style: GoogleFonts.manrope(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24)),
            Text(label,
                style: GoogleFonts.manrope(
                    color: AppColors.silver,
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
