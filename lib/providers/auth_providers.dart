import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

/// A single shared instance of the repository. `Provider` (not
/// StateProvider/StreamProvider) because the repository itself doesn't
/// change or emit values — it's just a bag of methods other providers call.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// The raw Firebase auth state: null when signed out, a User when signed in.
/// `StreamProvider` subscribes to `authStateChanges` once and caches the
/// latest value — every widget that watches this rebuilds automatically the
/// moment someone signs in or out, anywhere in the app.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// The signed-in user's Firestore profile (role, name, verification status).
/// `authStateProvider.select` means this only re-runs when the *uid*
/// changes, not on every token refresh — otherwise we'd resubscribe to
/// Firestore dozens of times for no reason.
final currentUserProfileProvider = StreamProvider<AppUser?>((ref) {
  final uid = ref.watch(authStateProvider.select((state) => state.value?.uid));
  if (uid == null) {
    // Nobody signed in — an empty stream that just emits nothing, rather
    // than null, keeps AsyncValue.loading() from flashing on sign-out.
    return const Stream.empty();
  }
  return ref.watch(authRepositoryProvider).watchUserProfile(uid);
});

/// Looks up any user's profile by uid — used on the opportunity details
/// screen to show the actual posting founder's bio/verification status,
/// as opposed to [currentUserProfileProvider] which is always the signed-in
/// user's own profile.
final startupProfileProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  return ref.watch(authRepositoryProvider).watchUserProfile(uid);
});

/// ALU-verified startup accounts, feeding the "ALU Startups" directory on
/// the student explore feed.
final verifiedStartupsProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.watch(authRepositoryProvider).watchVerifiedStartups();
});
