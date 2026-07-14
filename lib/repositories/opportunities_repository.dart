import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity.dart';

/// Firestore access for the `opportunities` collection. Named plural
/// (OpportunitiesRepository) to avoid colliding with the existing static
/// OpportunityRepository in models/opportunity_data.dart, which still
/// serves the hard-coded demo startups shown on the explore feed.
class OpportunitiesRepository {
  final FirebaseFirestore _firestore;

  OpportunitiesRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('opportunities');

  Future<void> postOpportunity(Opportunity opportunity) {
    return _collection.add(opportunity.toMap());
  }

  /// Updates an already-posted opportunity in place. Uses
  /// [Opportunity.toUpdateMap], not [Opportunity.toMap], so the original
  /// `createdAt` is preserved instead of being stamped over with the edit
  /// time (see that method's doc comment).
  Future<void> updateOpportunity(Opportunity opportunity) {
    return _collection.doc(opportunity.id).update(opportunity.toUpdateMap());
  }

  /// All opportunities posted by one founder, newest first — this is what
  /// the startup dashboard's "Active Listings" section watches.
  Stream<List<Opportunity>> watchMyOpportunities(String uid) {
    return _collection
        .where('postedByUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Opportunity.fromDoc).toList());
  }

  /// Every founder-posted opportunity, newest first — feeds the student
  /// explore screen alongside the static demo listings.
  Stream<List<Opportunity>> watchAllOpportunities() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Opportunity.fromDoc).toList());
  }
}
