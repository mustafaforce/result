import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/domain/usecases/get_current_auth_user.dart';
import '../../../auth/domain/usecases/sign_out_user.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/admin.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.signOutUser,
    required this.getCurrentAuthUser,
  });

  final SignOutUser signOutUser;
  final GetCurrentAuthUser getCurrentAuthUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await widget.signOutUser();

      if (!mounted) {
        return;
      }

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.getCurrentAuthUser();
    final fullName = user?.fullName;
    final email = user?.email ?? 'No email';
    final initials = (fullName ?? 'U').isNotEmpty
        ? (fullName ?? 'U')[0].toUpperCase()
        : 'U';

    final isAdmin = AdminConstants.isAdmin(user?.email);

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
                        child: Text(
                          initials,
                          style: GoogleFonts.manrope(
                            color: AppColors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName == null || fullName.isEmpty
                                ? 'Welcome'
                                : fullName,
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
                'Roomix',
                style: GoogleFonts.manrope(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Find your perfect roommate',
                style: GoogleFonts.manrope(
                  color: AppColors.silver,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Supabase connected',
                        style: GoogleFonts.manrope(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authentication is working',
                        style: GoogleFonts.manrope(
                          color: AppColors.silver,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.darkSurface,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, 'Home', true, null),
            _navItem(Icons.people_rounded, 'Matches', false, () {
              Navigator.of(context).pushNamed(AppRoutes.matchResults);
            }),
            _navItem(Icons.event_seat_rounded, 'Seats', false, () {
              Navigator.of(context).pushNamed(
                isAdmin ? AppRoutes.mySeats : AppRoutes.seatSearch,
              );
            }),
            _navItem(Icons.message_rounded, 'Requests', false, () {
              Navigator.of(context).pushNamed(AppRoutes.requests);
            }),
            _navItem(Icons.person_rounded, 'Profile', false, () {
              Navigator.of(context).pushNamed(AppRoutes.profile);
            }),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.green : AppColors.silver,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: isActive ? AppColors.green : AppColors.silver,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
