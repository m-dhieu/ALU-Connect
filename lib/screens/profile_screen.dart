import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';
import 'profile_setup_screen.dart';
import 'notification_screen.dart';

/// Presentation profile layer displaying individual ALU student metrics, tags, and parameters.
/// Features a modal contextual options drawer sheet and notification routing pipelines.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluOrange = Color(0xFFF19E18);

    final List<String> technicalSkills = ['React', 'Python', 'Flutter', 'Firebase', 'Figma', 'Node.js', 'Data Analysis', 'UX Research'];
    final List<String> ecosystemInterests = ['HealthTech', 'EdTech', 'AgriTech', 'FinTech'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Rich deep-green brand header banner block
          Container(
            color: aluDeepGreen,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60.0, bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                // Top Custom Header Control Utility Row Layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                      onPressed: () => _showSettingsBottomSheet(context, ref),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const NotificationScreen()),
                            );
                          },
                        ),
                        // Real-time unread alert badge tracker layer
                        Positioned(
                          top: 10,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Color(0xFFE53E3E), shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                
                // Avatar circle displaying leading initial token layer
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(color: aluOrange, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(
                    'M',
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 12),

                // Username Typography Node
                Text(
                  'm.dhieu',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),

                // Institutional campus status string line
                Text(
                  'ALU Student · Kigali Campus',
                  style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Horizontal Analytical KPI Counter Metrics Grid Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderMetricCell('2', 'Applied'),
                    _buildHeaderMetricCell('2', 'Saved'),
                    _buildHeaderMetricCell('1', 'Accepted'),
                  ],
                ),
              ],
            ),
          ),

          // Lower Section: Scrollable chip tags and descriptive card groups
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills',
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: technicalSkills.map((skill) => _buildStandardTagChip(skill, const Color(0xFFF1F3F5), Colors.black87)).toList(),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Interests',
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: ecosystemInterests.map((interest) => _buildStandardTagChip(interest, const Color(0xFFE6F4EA), const Color(0xFF137333))).toList(),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'About ALU Connect',
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Text(
                      'ALU Connect bridges the gap between students seeking internship experience and student-led startups within the ALU ecosystem. All startups on this platform have been verified by ALU\'s Innovation Hub.',
                      style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMetricCell(String numericValue, String descriptorLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          numericValue,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          descriptorLabel,
          style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStandardTagChip(String labelText, Color backdropColor, Color typographyColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: backdropColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        labelText,
        style: GoogleFonts.inter(color: typographyColor, fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Displays an interactive contextual menu options dashboard drawer sheet panel
  void _showSettingsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Settings', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Colors.black87),
                  title: Text('Edit Profile Tags', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileSetupScreen(isEditing: true)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.black87),
                  title: Text('Privacy Policy', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                const Divider(height: 24),
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: Color(0xFFE53E3E)),
                  title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 15, color: const Color(0xFFE53E3E))),
                  onTap: () {
                    Navigator.of(context).pop();
                    // AuthGate (main.dart) watches auth state and swaps
                    // back to OnboardingScreen automatically once this
                    // resolves — no manual navigation needed.
                    ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}