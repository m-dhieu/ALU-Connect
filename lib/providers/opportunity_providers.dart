import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/opportunity.dart';
import '../repositories/opportunities_repository.dart';
import 'auth_providers.dart';

final opportunitiesRepositoryProvider = Provider<OpportunitiesRepository>((ref) {
  return OpportunitiesRepository();
});

// store founder's postings & show empty when none exist
final myOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  final uid = ref.watch(authStateProvider.select((state) => state.value?.uid));
  if (uid == null) return const Stream.empty();
  return ref.watch(opportunitiesRepositoryProvider).watchMyOpportunities(uid);
});

final allPostedOpportunitiesProvider = StreamProvider<List<Opportunity>>((ref) {
  return ref.watch(opportunitiesRepositoryProvider).watchAllOpportunities();
});
