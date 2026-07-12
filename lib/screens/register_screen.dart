import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_user.dart';
import '../providers/auth_providers.dart';
import 'profile_setup_screen.dart';
import 'startup_profile_setup_screen.dart';

/// Account registration screen
/// institutional email validation for the ALU
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _isPasswordObscured = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Students must register with a real @alueducation.com or
  /// @alustudent.com address — that's the whole mechanism by which "only
  /// ALU students" access the platform, since we have no other way to
  /// check institutional membership. Founders aren't ALU students, so
  /// they're only held to looking like a real email; their legitimacy is
  /// instead gated by the isVerifiedStartup flag (an admin manually
  /// verifies each startup — see AppUser's doc comment).
  static const List<String> _aluStudentDomains = ['@alueducation.com', '@alustudent.com'];

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return _selectedRole == UserRole.student
          ? 'Please enter your ALU email address'
          : 'Please enter your email address';
    }

    final email = value.trim().toLowerCase();

    if (_selectedRole == UserRole.student) {
      if (!_aluStudentDomains.any(email.endsWith)) {
        return 'Students must register with an @alueducation.com or @alustudent.com email';
      }
      return null;
    }

    if (!_emailPattern.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _handleRegistrationSubmission() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(authRepositoryProvider).registerWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
            role: _selectedRole,
          );

      if (!mounted) return;

      // Registration succeeds -> creates the Auth account AND the Firestore
      // profile doc in one call (see AuthRepository.registerWithEmail).
      // From here we still push straight to profile setup ourselves, rather
      // than waiting on AuthGate, because a brand-new account should always
      // land on "finish your profile" once, regardless of what AuthGate
      // would otherwise route to.
      if (_selectedRole == UserRole.startup) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const StartupProfileSetupScreen(isEditing: false),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ProfileSetupScreen(isEditing: false),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authErrorMessage(e))),
      );
    } on FirebaseException catch (e) {
      // Covers Firestore errors from the profile-doc write (e.g. rejected
      // by firestore.rules) — a different exception type than
      // FirebaseAuthException, so it needs its own catch clause or it
      // would previously slip through uncaught, leaving the button stuck
      // on its loading spinner with no feedback at all.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create your profile: ${e.message ?? e.code}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      default:
        return 'Registration failed: ${e.message ?? e.code}';
    }
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade400,
        fontSize: 15,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(0xFF0C4E33),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluLightBg = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Typography Layout Elements
                Text(
                  'Join ALU Connect',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to get started',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),

                // Field Section Label: Role Selection
                Text(
                  'I AM A',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Horizontal Custom Role Selector Widget Grid Matrix
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRole = UserRole.student),
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.student
                                ? aluDeepGreen
                                : aluLightBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedRole == UserRole.student
                                  ? aluDeepGreen
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🎓', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                'Student',
                                style: GoogleFonts.inter(
                                  color: _selectedRole == UserRole.student
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedRole = UserRole.startup),
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.startup
                                ? aluDeepGreen
                                : aluLightBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedRole == UserRole.startup
                                  ? aluDeepGreen
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🚀', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                'Startup',
                                style: GoogleFonts.inter(
                                  color: _selectedRole == UserRole.startup
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Field Section Label: Name Form Input Layout Block
                Text(
                  'FULL NAME',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  decoration: _buildInputDecoration('Amara Diallo'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Please enter your name'
                          : null,
                ),
                const SizedBox(height: 24),

                // Field Section Label: Email Entry Form Input Layout Block
                Text(
                  'EMAIL',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: _buildInputDecoration(
                    _selectedRole == UserRole.student
                        ? 'a.diallo@alueducation.com'
                        : 'you@yourstartup.com',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 24),

                // Field Section Label: Password Form Entry Input Layout Block
                Text(
                  'PASSWORD',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  autocorrect: false,
                  decoration: _buildInputDecoration('••••••••').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade500,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordObscured = !_isPasswordObscured,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      (value == null || value.length < 6)
                          ? 'Password must be at least 6 characters long'
                          : null,
                ),
                const SizedBox(height: 36),

                // Form Registration Action Commit Control Layout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleRegistrationSubmission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aluDeepGreen,
                      disabledBackgroundColor: aluDeepGreen.withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'Create account',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Navigation Alternate Option Switch Context Flow Subtext Anchor
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Sign in',
                        style: GoogleFonts.inter(
                          color: aluDeepGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}