import '../../domain/entities/seat.dart';
import '../../domain/errors/seat_failure.dart';
import '../../domain/repositories/seat_repository.dart';
import '../datasources/seat_remote_datasource.dart';
import '../models/seat_model.dart';

class SeatRepositoryImpl implements SeatRepository {
  SeatRepositoryImpl(this._remoteDataSource);

  final SeatRemoteDataSource _remoteDataSource;

  Future<List<Seat>> _attachCounts(List<Seat> seats) async {
    if (seats.isEmpty) return seats;
    final ids = seats.map((s) => s.id).toList();
    final counts = await _remoteDataSource.getOccupantCounts(ids);
    return seats.map((s) {
      return Seat(
        id: s.id,
        ownerId: s.ownerId,
        title: s.title,
        description: s.description,
        hallName: s.hallName,
        seatNumber: s.seatNumber,
        location: s.location,
        monthlyFee: s.monthlyFee,
        isAvailable: s.isAvailable,
        capacity: s.capacity,
        facilities: s.facilities,
        occupantCount: counts[s.id] ?? 0,
      );
    }).toList();
  }

  @override
  Future<List<Seat>> getAllAvailable() async {
    try {
      final rows = await _remoteDataSource.getAllAvailable();
      final seats = rows.map((r) => SeatModel.fromJson(r).toEntity()).toList();
      return _attachCounts(seats);
    } on SeatFailure {
      rethrow;
    } catch (e) {
      throw const SeatFailure('Failed to load seats.');
    }
  }

  @override
  Future<List<Seat>> getMySeats() async {
    try {
      final rows = await _remoteDataSource.getMySeats();
      final seats = rows.map((r) => SeatModel.fromJson(r).toEntity()).toList();
      return _attachCounts(seats);
    } on SeatFailure {
      rethrow;
    } catch (e) {
      throw const SeatFailure('Failed to load your seats.');
    }
  }

  @override
  Future<void> createSeat(Seat seat) async {
    try {
      final model = SeatModel.fromEntity(seat);
      await _remoteDataSource.createSeat(model.toJson());
    } on SeatFailure {
      rethrow;
    } catch (e) {
      throw const SeatFailure('Failed to create seat.');
    }
  }

  @override
  Future<void> updateSeat(Seat seat) async {
    try {
      final model = SeatModel.fromEntity(seat);
      await _remoteDataSource.updateSeat(model.toJson());
    } on SeatFailure {
      rethrow;
    } catch (e) {
      throw const SeatFailure('Failed to update seat.');
    }
  }

  @override
  Future<void> deleteSeat(String seatId) async {
    try {
      await _remoteDataSource.deleteSeat(seatId);
    } on SeatFailure {
      rethrow;
    } catch (e) {
      throw const SeatFailure('Failed to delete seat.');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getOccupants(String seatId) async {
    try {
      return await _remoteDataSource.getOccupants(seatId);
    } catch (e) {
      throw const SeatFailure('Failed to load occupants.');
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getOccupantPrefs(
      List<String> userIds) async {
    try {
      return await _remoteDataSource.getOccupantPrefs(userIds);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getOccupantMatchingPrefs(
      List<String> userIds) async {
    try {
      return await _remoteDataSource.getOccupantMatchingPrefs(userIds);
    } catch (e) {
      return {};
    }
  }
}
