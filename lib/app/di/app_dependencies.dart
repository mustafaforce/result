import '../../core/services/supabase_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_auth_user.dart';
import '../../features/auth/domain/usecases/is_user_logged_in.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_out_user.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/matching/data/datasources/matching_remote_datasource.dart';
import '../../features/matching/data/repositories/matching_repository_impl.dart';
import '../../features/matching/domain/repositories/matching_repository.dart';
import '../../features/matching/domain/usecases/get_my_preferences.dart';
import '../../features/matching/domain/usecases/get_match_suggestions.dart';
import '../../features/matching/domain/usecases/upsert_my_preferences.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_my_profile.dart';
import '../../features/profile/domain/usecases/upsert_my_profile.dart';
import '../../features/requests/data/datasources/request_remote_datasource.dart';
import '../../features/requests/data/repositories/request_repository_impl.dart';
import '../../features/requests/domain/repositories/request_repository.dart';
import '../../features/requests/domain/usecases/get_my_requests.dart';
import '../../features/requests/domain/usecases/respond_to_request.dart';
import '../../features/requests/domain/usecases/send_roommate_request.dart';
import '../../features/seats/data/datasources/seat_remote_datasource.dart';
import '../../features/seats/data/repositories/seat_repository_impl.dart';
import '../../features/seats/domain/repositories/seat_repository.dart';
import '../../features/seats/domain/usecases/create_seat.dart';
import '../../features/seats/domain/usecases/delete_seat.dart';
import '../../features/seats/domain/usecases/get_available_seats.dart';
import '../../features/seats/domain/usecases/get_my_seats.dart';
import '../../features/seats/domain/usecases/get_occupants.dart';
import '../../features/seats/domain/usecases/update_seat.dart';
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/ratings/data/datasources/rating_remote_datasource.dart';
import '../../features/ratings/data/repositories/rating_repository_impl.dart';
import '../../features/ratings/domain/repositories/rating_repository.dart';
import '../../features/ratings/domain/usecases/get_average_rating.dart';
import '../../features/ratings/domain/usecases/get_user_ratings.dart';
import '../../features/ratings/domain/usecases/submit_rating.dart';
import '../../features/seats_applications/data/datasources/application_remote_datasource.dart';
import '../../features/seats_applications/data/repositories/application_repository_impl.dart';
import '../../features/seats_applications/domain/repositories/application_repository.dart';
import '../../features/seats_applications/domain/usecases/apply_for_seat.dart';
import '../../features/seats_applications/domain/usecases/get_applications.dart';
import '../../features/seats_applications/domain/usecases/respond_to_application.dart';

class AppDependencies {
  AppDependencies._(
    AuthRepository authRepository,
    ProfileRepository profileRepository,
    MatchingRepository matchingRepository,
    RequestRepository requestRepository,
    SeatRepository seatRepository,
    ApplicationRepository applicationRepository,
    RatingRepository ratingRepository,
  ) : signInWithEmail = SignInWithEmail(authRepository),
      signUpWithEmail = SignUpWithEmail(authRepository),
      signOutUser = SignOutUser(authRepository),
      isUserLoggedIn = IsUserLoggedIn(authRepository),
      getCurrentAuthUser = GetCurrentAuthUser(authRepository),
      getMyProfile = GetMyProfile(profileRepository),
      upsertMyProfile = UpsertMyProfile(profileRepository),
      getMyPreferences = GetMyPreferences(matchingRepository),
      upsertMyPreferences = UpsertMyPreferences(matchingRepository),
      getMatchSuggestions = GetMatchSuggestions(matchingRepository),
      sendRoommateRequest = SendRoommateRequest(requestRepository),
      respondToRequest = RespondToRequest(requestRepository),
      getMyRequests = GetMyRequests(requestRepository),
      getAvailableSeats = GetAvailableSeats(seatRepository),
      getMySeats = GetMySeats(seatRepository),
      getOccupants = GetOccupants(seatRepository),
      createSeat = CreateSeat(seatRepository),
      updateSeat = UpdateSeat(seatRepository),
      deleteSeat = DeleteSeat(seatRepository),
      adminRemoteDataSource = AdminRemoteDataSource(),
      applyForSeat = ApplyForSeat(applicationRepository),
      respondToApplication = RespondToApplication(applicationRepository),
      getApplications = GetApplications(applicationRepository),
      submitRating = SubmitRating(ratingRepository),
      getUserRatings = GetUserRatings(ratingRepository),
      getAverageRating = GetAverageRating(ratingRepository);

  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOutUser signOutUser;
  final IsUserLoggedIn isUserLoggedIn;
  final GetCurrentAuthUser getCurrentAuthUser;
  final GetMyProfile getMyProfile;
  final UpsertMyProfile upsertMyProfile;
  final GetMyPreferences getMyPreferences;
  final UpsertMyPreferences upsertMyPreferences;
  final GetMatchSuggestions getMatchSuggestions;
  final SendRoommateRequest sendRoommateRequest;
  final RespondToRequest respondToRequest;
  final GetMyRequests getMyRequests;
  final GetAvailableSeats getAvailableSeats;
  final GetMySeats getMySeats;
  final GetOccupants getOccupants;
  final CreateSeat createSeat;
  final UpdateSeat updateSeat;
  final DeleteSeat deleteSeat;
  final AdminRemoteDataSource adminRemoteDataSource;
  final ApplyForSeat applyForSeat;
  final RespondToApplication respondToApplication;
  final GetApplications getApplications;
  final SubmitRating submitRating;
  final GetUserRatings getUserRatings;
  final GetAverageRating getAverageRating;

  static Future<AppDependencies> initialize() async {
    await SupabaseService.initialize();

    final remoteDataSource = AuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);

    final profileRemoteDataSource = ProfileRemoteDataSource();
    final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);

    final matchingRemoteDataSource = MatchingRemoteDataSource();
    final matchingRepository = MatchingRepositoryImpl(matchingRemoteDataSource);

    final requestRemoteDataSource = RequestRemoteDataSource();
    final requestRepository =
        RequestRepositoryImpl(requestRemoteDataSource);

    final seatRemoteDataSource = SeatRemoteDataSource();
    final seatRepository = SeatRepositoryImpl(seatRemoteDataSource);

    final applicationRemoteDataSource = ApplicationRemoteDataSource();
    final applicationRepository =
        ApplicationRepositoryImpl(applicationRemoteDataSource);

    final ratingRemoteDataSource = RatingRemoteDataSource();
    final ratingRepository =
        RatingRepositoryImpl(ratingRemoteDataSource);

    return AppDependencies._(
      authRepository,
      profileRepository,
      matchingRepository,
      requestRepository,
      seatRepository,
      applicationRepository,
      ratingRepository,
    );
  }
}
