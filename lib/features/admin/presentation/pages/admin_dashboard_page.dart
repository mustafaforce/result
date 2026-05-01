import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../auth/domain/usecases/get_current_auth_user.dart';
import '../../../auth/domain/usecases/sign_out_user.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({
    super.key,
    required this.signOutUser,
    required this.getCurrentAuthUser,
  });

  final SignOutUser signOutUser;
  final GetCurrentAuthUser getCurrentAuthUser;

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await widget.signOutUser();
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
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
                        child: Icon(
                          Icons.shield_rounded,
                          color: AppColors.green,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Panel',
                            style: GoogleFonts.manrope(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.manrope(
                              color: AppColors.silver,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: _isLoggingOut
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.green,
                            ),
                          )
                        : const Icon(
                            Icons.logout_rounded,
                            color: AppColors.silver,
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Hall Management',
                style: GoogleFonts.manrope(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor and manage hall & mess operations',
                style: GoogleFonts.manrope(
                  color: AppColors.silver,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _adminCard(
                      icon: Icons.people_rounded,
                      title: 'Users',
                      subtitle: 'Manage accounts',
                      onTap: () {},
                    ),
                    _adminCard(
                      icon: Icons.event_seat_rounded,
                      title: 'Seats',
                      subtitle: 'Hall & mess seats',
                      onTap: () {},
                    ),
                    _adminCard(
                      icon: Icons.flag_rounded,
                      title: 'Reports',
                      subtitle: 'Flagged content',
                      onTap: () {},
                    ),
                    _adminCard(
                      icon: Icons.verified_rounded,
                      title: 'Verify',
                      subtitle: 'Verify accounts',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(icon, color: AppColors.green, size: 28),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  color: AppColors.silver,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
