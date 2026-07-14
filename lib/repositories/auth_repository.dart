import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

// handle Firebase Auth & user Firestore data
// keep screens from calling Firebase directly
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // create Firebase account & user profile together
  // remove account if profile creation fails
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'unknown', message: 'Account creation returned no user.');
    }

    final appUser = AppUser(
      uid: user.uid,
      email: email,
      fullName: fullName,
      role: role,
      isVerifiedStartup: false,
    );

    try {
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    } catch (e) {
      await user.delete();
      rethrow;
    }
  }

  // update startup details without changing verification status
  Future<void> updateStartupProfile({
    required String uid,
    required String tagline,
    required String about,
    required String companySize,
    required String industry,
    required List<String> domains,
  }) {
    return _firestore.collection('users').doc(uid).update({
      'tagline': tagline,
      'about': about,
      'companySize': companySize,
      'industry': industry,
      'domains': domains,
    });
  }

  Future<void> signInWithEmail({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  // stream current user's profile updates
  Stream<AppUser?> watchUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.id, doc.data()!);
    });
  }

  // get verified startup accounts for the explore feed
  Stream<List<AppUser>> watchVerifiedStartups() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'startup')
        .where('isVerifiedStartup', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AppUser.fromMap(doc.id, doc.data())).toList());
  }
}
