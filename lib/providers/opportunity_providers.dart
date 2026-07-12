import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/opportunity.dart';
import '../repositories/opportunities_repository.dart';
import 'auth_providers.dart';

final opportunitiesRepositoryProvider = Provider<OpportunitiesRepository>((ref) {
  return OpportunitiesRepository();
});

/// The signed-in founder's own postings — empty for a brand-new account
/// until they publish something, which is exactly the "start from zero"
/// behavior the dashboard's empty state is built around.
final myOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final uid = ref.watch(authStateProvider.select((state) => state.value?.uid));
  if (uid == null) return const Stream.empty();
  return ref.watch(opportunitiesRepositoryProvider).watchMyOpportunities(uid);
});

/// Every founder-posted opportunity, for the student explore feed.
final allPostedOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesRepositoryProvider).watchAllOpportunities();
});
