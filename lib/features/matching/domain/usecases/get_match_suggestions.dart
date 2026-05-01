import '../entities/match_candidate.dart';
import '../services/compatibility_scorer.dart';
import '../repositories/matching_repository.dart';

class GetMatchSuggestions {
  GetMatchSuggestions(this._repository);

  final MatchingRepository _repository;

  Future<List<MatchCandidate>> call() async {
    final myData = await _repository.getMyCandidateData();
    if (myData == null) return [];

    final candidates = await _repository.getAllCandidates();
    final scorer = CompatibilityScorer();

    final results = <MatchCandidate>[];
    for (final c in candidates) {
      final score = scorer.score(
        myProfile: myData.profile,
        myPreferences: myData.preferences,
        theirProfile: c.profile,
        theirPreferences: c.preferences,
      );

      final p = c.profile;
      results.add(MatchCandidate(
        userId: c.userId,
        fullName: p.fullName,
        department: p.department,
        academicYear: p.academicYear,
        score: score,
      ));
    }

    results.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
    return results;
  }
}
