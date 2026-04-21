import 'package:flutter/material.dart';

import '../../../auth/domain/usecases/get_current_auth_user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/errors/profile_failure.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/upsert_my_profile.dart';

class ProfileFormController extends ChangeNotifier {
  ProfileFormController({
    required this.getCurrentAuthUser,
    required this.getMyProfile,
    required this.upsertMyProfile,
  });

  final GetCurrentAuthUser getCurrentAuthUser;
  final GetMyProfile getMyProfile;
  final UpsertMyProfile upsertMyProfile;

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final departmentController = TextEditingController();
  final yearController = TextEditingController();
  final budgetController = TextEditingController();
  final bioController = TextEditingController();

  bool isSmoker = false;
  bool isNightOwl = false;
  int cleanliness = 3;
  bool isLoading = true;
  bool isSaving = false;

  String get email => getCurrentAuthUser()?.email ?? 'No email';

  String get displayName {
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      return 'Roomix User';
    }
    return name;
  }

  String get avatarText => displayName[0].toUpperCase();

  Future<String?> loadProfile() async {
    final authFullName = getCurrentAuthUser()?.fullName?.trim() ?? '';
    if (authFullName.isNotEmpty) {
      fullNameController.text = authFullName;
    }

    String? message;
    try {
      final profile = await getMyProfile();
      if (profile != null) {
        _applyProfile(profile);
      }
    } on ProfileFailure catch (e) {
      message = e.message;
    } catch (_) {
      message = 'Could not load profile.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return message;
  }

  Future<String?> saveProfile() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid || isSaving) {
      return null;
    }

    final yearText = yearController.text.trim();
    final budgetText = budgetController.text.trim();

    final profile = UserProfile(
      fullName: fullNameController.text.trim(),
      department: _optionalText(departmentController.text),
      academicYear: yearText.isEmpty ? null : int.tryParse(yearText),
      monthlyBudget: budgetText.isEmpty ? null : double.tryParse(budgetText),
      bio: _optionalText(bioController.text),
      isSmoker: isSmoker,
      isNightOwl: isNightOwl,
      cleanlinessLevel: cleanliness,
    );

    isSaving = true;
    notifyListeners();

    String message;
    try {
      await upsertMyProfile(profile);
      message = 'Profile saved.';
    } on ProfileFailure catch (e) {
      message = e.message;
    } catch (_) {
      message = 'Failed to save profile.';
    } finally {
      isSaving = false;
      notifyListeners();
    }

    return message;
  }

  void onFullNameChanged() {
    notifyListeners();
  }

  void setSmoker(bool value) {
    isSmoker = value;
    notifyListeners();
  }

  void setNightOwl(bool value) {
    isNightOwl = value;
    notifyListeners();
  }

  void setCleanliness(double value) {
    cleanliness = value.round();
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    departmentController.dispose();
    yearController.dispose();
    budgetController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _applyProfile(UserProfile profile) {
    fullNameController.text = profile.fullName;
    departmentController.text = profile.department ?? '';
    yearController.text = profile.academicYear?.toString() ?? '';
    budgetController.text = profile.monthlyBudget?.toStringAsFixed(0) ?? '';
    bioController.text = profile.bio ?? '';
    isSmoker = profile.isSmoker;
    isNightOwl = profile.isNightOwl;
    cleanliness = profile.cleanlinessLevel;
  }

  String? _optionalText(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return null;
    }
    return normalized;
  }
}
