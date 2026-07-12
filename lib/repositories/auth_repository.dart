import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

/// Everything the app needs to talk to Firebase Auth + the `users`
/// Firestore collection, in one place. Screens never call FirebaseAuth
/// directly — they go through here, so this class is the single seam
/// we'd need to change if the backend ever moved off Firebase.
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fires every time the signed-in user changes (sign in, sign out, token
  /// refresh). Riverpod turns this into a StreamProvider so the whole app's
  /// UI reacts automatically — this is our "auth state" source of truth.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Creates a Firebase Auth account, then writes the matching profile
  /// document to `users/{uid}`. These are two separate API calls against
  /// two different services, so if the second one fails we roll back the
  /// first — otherwise we'd end up with an auth account with no profile,
  /// which would leave the app unable to tell if they're a student or a
  /// startup on their next sign-in.
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
      // Always false at creation — firestore.rules enforces this server-side
      // (a new profile doc must have isVerifiedStartup == false), and the
      // field is meaningless for students anyway (see AppUser's doc comment).
      isVerifiedStartup: false,
    );

    try {
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    } catch (e) {
      // Profile write failed — delete the orphaned auth account rather than
      // leaving a half-created user the app can never fully sign in as.
      await user.delete();
      rethrow;
    }
  }

  Future<void> signInWithEmail({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  /// Streams the current user's profile document in real time. Using a
  /// stream (not a one-off `get()`) means if an admin later verifies this
  /// startup's account, the UI updates live without the user needing to
  /// log out and back in.
  Stream<AppUser?> watchUserProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.id, doc.data()!);
    });
  }
}
