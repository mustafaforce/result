import '../../domain/entities/roommate_request.dart';
import '../../domain/errors/request_failure.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_datasource.dart';
import '../models/roommate_request_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  RequestRepositoryImpl(this._remoteDataSource);

  final RequestRemoteDataSource _remoteDataSource;

  @override
  Future<void> sendRequest({required String toUserId}) async {
    try {
      await _remoteDataSource.sendRequest(toUserId: toUserId);
    } on RequestFailure {
      rethrow;
    } catch (e) {
      throw const RequestFailure('Failed to send request.');
    }
  }

  @override
  Future<void> respondToRequest({
    required String requestId,
    required bool accept,
  }) async {
    try {
      await _remoteDataSource.respondToRequest(
        requestId: requestId,
        accept: accept,
      );
    } on RequestFailure {
      rethrow;
    } catch (e) {
      throw const RequestFailure('Failed to respond to request.');
    }
  }

  @override
  Future<List<RoommateRequest>> getMySentRequests() async {
    try {
      final rows = await _remoteDataSource.getMySentRequests();
      return rows.map((r) => RoommateRequestModel.fromJson(r).toEntity()).toList();
    } catch (e) {
      throw const RequestFailure('Failed to load requests.');
    }
  }

  @override
  Future<List<RoommateRequest>> getMyReceivedRequests() async {
    try {
      final rows = await _remoteDataSource.getMyReceivedRequests();
      return rows.map((r) => RoommateRequestModel.fromJson(r).toEntity()).toList();
    } catch (e) {
      throw const RequestFailure('Failed to load requests.');
    }
  }
}
