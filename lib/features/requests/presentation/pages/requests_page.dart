import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/roommate_request.dart';
import '../../domain/usecases/get_my_requests.dart';
import '../../domain/usecases/respond_to_request.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({
    super.key,
    required this.getMyRequests,
    required this.respondToRequest,
  });

  final GetMyRequests getMyRequests;
  final RespondToRequest respondToRequest;

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _sent = <RoommateRequest>[];
  final _received = <RoommateRequest>[];
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
      final sent = await widget.getMyRequests.sent();
      final received = await widget.getMyRequests.received();
      if (!mounted) return;
      setState(() {
        _sent
          ..clear()
          ..addAll(sent);
        _received
          ..clear()
          ..addAll(received);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRespond(
    String requestId,
    bool accept,
  ) async {
    try {
      await widget.respondToRequest(requestId: requestId, accept: accept);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to respond')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roommate Requests'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.green,
          unselectedLabelColor: AppColors.silver,
          indicatorColor: AppColors.green,
          labelStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.4,
          ),
          tabs: [
            Tab(text: 'RECEIVED (${_received.length})'),
            Tab(text: 'SENT (${_sent.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _requestList(_received, isSent: false),
                _requestList(_sent, isSent: true),
              ],
            ),
    );
  }

  Widget _requestList(List<RoommateRequest> requests, {required bool isSent}) {
    if (requests.isEmpty) {
      return Center(
        child: Text(
          isSent ? 'No sent requests' : 'No received requests',
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
      itemCount: requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final req = requests[index];
        final name = isSent ? req.toUserName : req.fromUserName;
        return _requestCard(req, name ?? 'Unknown', isSent);
      },
    );
  }

  Widget _requestCard(
    RoommateRequest req,
    String name,
    bool isSent,
  ) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.manrope(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _statusChip(req.status),
                ],
              ),
            ),
            if (!isSent && req.isPending)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _handleRespond(req.id, true),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.green,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _handleRespond(req.id, false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.negativeRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.negativeRed,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final data = switch (status) {
      'pending' => (AppColors.warningOrange, 'Pending'),
      'accepted' => (AppColors.green, 'Accepted'),
      'rejected' => (AppColors.negativeRed, 'Rejected'),
      _ => (AppColors.silver, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
