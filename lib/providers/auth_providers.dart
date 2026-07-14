import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

// shared repository instance
// use Provider as repository doesn't emit changes
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// track Firebase sign in/out state & update widgets automatically when auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// get signed-in user's profile & update profile when user changes
final currentUserProfileProvider = StreamProvider<AppUser?>((ref) {
  final uid = ref.watch(authStateProvider.select((state) => state.value?.uid));
  if (uid == null) {
    return const Stream.empty();
  }
  return ref.watch(authRepositoryProvider).watchUserProfile(uid);
});

// get user's profile by uid & show founder details on opportunity pages
final startupProfileProvider = StreamProvider.family<AppUser?, String>((ref, uid) {
  return ref.watch(authRepositoryProvider).watchUserProfile(uid);
});

// store verified startup accounts for the explore feed
final verifiedStartupsProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.watch(authRepositoryProvider).watchVerifiedStartups();
});
