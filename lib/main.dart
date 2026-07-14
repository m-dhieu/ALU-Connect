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

  // initialize Firebase before running app
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

// open correct screen depending on user sign in state
// update screen automatically when user signs in/out
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
        // onboard user if not signed in yet
        if (user == null) {
          return const OnboardingScreen();
        }

        // open dashboard based on user's profile 
        final profileState = ref.watch(currentUserProfileProvider);
        return profileState.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => Scaffold(
            body: Center(child: Text('Could not load your profile: $error')),
          ),
          data: (profile) {
            if (profile == null) {
              // if profile is missing, send user to onboarding
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
