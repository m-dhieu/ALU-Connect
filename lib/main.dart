import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'models/app_user.dart';
import 'providers/auth_providers.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/startup_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase must finish connecting before the app renders anything that
  // might touch Auth or Firestore, so this is awaited ahead of runApp.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: ALUConnectApp(),
    ),
  );
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0C4E33),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthGate(),
    );
  }
}

/// Decides which screen the app opens on, based on live Firebase Auth state.
///
/// This is a ConsumerWidget (not StatelessWidget) so it can `watch` the auth
/// providers — Riverpod rebuilds it automatically the instant someone signs
/// in or out anywhere in the app, with no manual navigation calls needed at
/// the sign-in/sign-out call sites themselves.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Something went wrong: $error')),
      ),
      data: (user) {
        // Nobody signed in yet — show the marketing/login entry point.
        if (user == null) {
          return const OnboardingScreen();
        }

        // Signed in: now wait on their profile document to learn whether
        // they're a student or a startup, and route accordingly.
        final profileState = ref.watch(currentUserProfileProvider);
        return profileState.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => Scaffold(
            body: Center(child: Text('Could not load your profile: $error')),
          ),
          data: (profile) {
            if (profile == null) {
              // Auth account exists but the Firestore profile write hasn't
              // landed yet (or failed) — safest fallback is the onboarding
              // flow rather than crashing on a null role.
              return const OnboardingScreen();
            }
            return profile.role == UserRole.startup
                ? const StartupDashboardScreen()
                : const HomeScreen();
          },
        );
      },
    );
  }
}
