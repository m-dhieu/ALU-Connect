import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity.dart';

// handle Firestore access for opportunities
// keep separate from static demo opportunity data
class OpportunitiesRepository {
  final FirebaseFirestore _firestore;

  OpportunitiesRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('opportunities');

  Future<void> postOpportunity(Opportunity opportunity) {
    return _collection.add(opportunity.toMap());
  }

  // update opportunity without changing original posting date
  Future<void> updateOpportunity(Opportunity opportunity) {
    return _collection.doc(opportunity.id).update(opportunity.toUpdateMap());
  }

  Stream<List<Opportunity>> watchMyOpportunities(String uid) {
    return _collection
        .where('postedByUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Opportunity.fromDoc).toList());
  }

  Stream<List<Opportunity>> watchAllOpportunities() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Opportunity.fromDoc).toList());
  }
}
