import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key, required this.adminRemoteDataSource});

  final AdminRemoteDataSource adminRemoteDataSource;

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final users = await widget.adminRemoteDataSource.getAllUsers();
      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleVerified(String userId, bool verified) async {
    try {
      await widget.adminRemoteDataSource.setUserVerified(
        userId: userId,
        verified: verified,
      );
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update')),
      );
    }
  }

  Future<void> _toggleFlagged(String userId, bool flagged) async {
    try {
      await widget.adminRemoteDataSource.setUserFlagged(
        userId: userId,
        flagged: flagged,
      );
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _userCard(_users[i]),
              ),
            ),
    );
  }

  Widget _userCard(Map<String, dynamic> user) {
    final name = user['full_name'] as String? ?? 'Unknown';
    final isVerified = user['is_verified'] as bool? ?? false;
    final isFlagged = user['is_flagged'] as bool? ?? false;
    final userId = user['id'] as String;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.midDark,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.manrope(
                color: AppColors.green,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.manrope(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isVerified)
                      Icon(Icons.verified_rounded,
                          color: AppColors.announcementBlue, size: 16),
                    if (isFlagged)
                      Icon(Icons.flag_rounded,
                          color: AppColors.negativeRed, size: 16),
                  ],
                ),
                if (user['department'] != null)
                  Text(
                    user['department'] as String,
                    style: GoogleFonts.manrope(
                      color: AppColors.silver,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleVerified(userId, !isVerified),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: (isVerified
                        ? AppColors.announcementBlue
                        : AppColors.silver)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isVerified ? 'VERIFIED' : 'VERIFY',
                style: GoogleFonts.manrope(
                  color: isVerified
                      ? AppColors.announcementBlue
                      : AppColors.silver,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _toggleFlagged(userId, !isFlagged),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: (isFlagged
                        ? AppColors.negativeRed
                        : AppColors.silver)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isFlagged ? 'FLAGGED' : 'FLAG',
                style: GoogleFonts.manrope(
                  color: isFlagged
                      ? AppColors.negativeRed
                      : AppColors.silver,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
