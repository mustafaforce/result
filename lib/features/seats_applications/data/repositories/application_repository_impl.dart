import '../../domain/entities/seat_application.dart';
import '../../domain/errors/application_failure.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application_remote_datasource.dart';
import '../models/seat_application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  ApplicationRepositoryImpl(this._remoteDataSource);

  final ApplicationRemoteDataSource _remoteDataSource;

  @override
  Future<void> applyForSeat({required String seatId}) async {
    try {
      await _remoteDataSource.applyForSeat(seatId: seatId);
    } on ApplicationFailure {
      rethrow;
    } catch (e) {
      throw const ApplicationFailure('Failed to apply.');
    }
  }

  @override
  Future<void> respondToApplication({
    required String applicationId,
    required bool accept,
  }) async {
    try {
      await _remoteDataSource.respondToApplication(
        applicationId: applicationId,
        accept: accept,
      );
    } on ApplicationFailure {
      rethrow;
    } catch (e) {
      throw const ApplicationFailure('Failed to respond.');
    }
  }

  @override
  Future<List<SeatApplication>> getMyApplications() async {
    try {
      final rows = await _remoteDataSource.getMyApplications();
      return rows
          .map((r) => SeatApplicationModel.fromJson(r).toEntity())
          .toList();
    } catch (e) {
      throw const ApplicationFailure('Failed to load applications.');
    }
  }

  @override
  Future<List<SeatApplication>> getApplicationsForMySeats() async {
    try {
      final rows = await _remoteDataSource.getApplicationsForMySeats();
      return rows
          .map((r) => SeatApplicationModel.fromJson(r).toEntity())
          .toList();
    } catch (e) {
      throw const ApplicationFailure('Failed to load applications.');
    }
  }
}
