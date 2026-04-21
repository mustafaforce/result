import 'package:flutter/material.dart';

import '../../../auth/domain/usecases/get_current_auth_user.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/upsert_my_profile.dart';
import '../controllers/profile_form_controller.dart';
import '../widgets/basic_info_section.dart';
import '../widgets/housing_section.dart';
import '../widgets/lifestyle_section.dart';
import '../widgets/profile_header_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.getCurrentAuthUser,
    required this.getMyProfile,
    required this.upsertMyProfile,
  });

  final GetCurrentAuthUser getCurrentAuthUser;
  final GetMyProfile getMyProfile;
  final UpsertMyProfile upsertMyProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileFormController(
      getCurrentAuthUser: widget.getCurrentAuthUser,
      getMyProfile: widget.getMyProfile,
      upsertMyProfile: widget.upsertMyProfile,
    );
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final message = await _controller.loadProfile();
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    final message = await _controller.saveProfile();
    if (!mounted || message == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE9F8F1), Color(0xFFF7FCFA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: _controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProfileHeaderCard(
                              fullName: _controller.displayName,
                              email: _controller.email,
                              avatarText: _controller.avatarText,
                            ),
                            const SizedBox(height: 14),
                            BasicInfoSection(
                              fullNameController:
                                  _controller.fullNameController,
                              departmentController:
                                  _controller.departmentController,
                              yearController: _controller.yearController,
                              onFullNameChanged: _controller.onFullNameChanged,
                            ),
                            const SizedBox(height: 14),
                            LifestyleSection(
                              isSmoker: _controller.isSmoker,
                              isNightOwl: _controller.isNightOwl,
                              cleanliness: _controller.cleanliness,
                              onSmokerChanged: _controller.setSmoker,
                              onNightOwlChanged: _controller.setNightOwl,
                              onCleanlinessChanged: _controller.setCleanliness,
                            ),
                            const SizedBox(height: 14),
                            HousingSection(
                              budgetController: _controller.budgetController,
                              bioController: _controller.bioController,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: _controller.isSaving ? null : _save,
                              icon: _controller.isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: Text(
                                _controller.isSaving
                                    ? 'Saving...'
                                    : 'Save Profile',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
