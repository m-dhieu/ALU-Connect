import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'startup_profile_setup_screen.dart';
import 'notification_screen.dart';
import 'onboarding_screen.dart';

/// Presentation profile tab showing corporate venture stats, operational metadata fields, and actions.
class StartupMyProfileScreen extends StatelessWidget {
  const StartupMyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color companyThemeColor = Color(0xFF10B981);
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluOrange = Color(0xFFF19E18);

    final List<String> domains = ['Engineering', 'Design', 'Marketing'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top branding layout panel container banner block
          Container(
            color: companyThemeColor,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60.0, bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                // Top Utilities Header Icon Controls Row Block
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                      onPressed: () => _showStartupSettingsBottomSheet(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 26),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NotificationScreen()),
                        );
                      },
                    ),
                  ],
                ),

                // Venture Initial Emblem Badge Container Frame
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'ZH',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black),
                  ),
                ),
                const SizedBox(height: 14),

                // Corporate Identity Typography Block with Verification Seal Inline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zuri Health',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.black),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: aluOrange, borderRadius: BorderRadius.circular(4)),
                      child: Text('ALU VERIFIED', style: GoogleFonts.inter(color: Colors.black, fontSize: 8, fontWeight: FontWeight.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Subtitle Bio Text context string line
                Text(
                  'Democratizing healthcare access across Africa',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Horizontal Operational Matrix Performance Row Cells
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderMetricCell('2', 'Active Roles'),
                    _buildHeaderMetricCell('4', 'Total Apps'),
                    _buildHeaderMetricCell('1', 'Interviews'),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable core descriptive body content maps
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.black)),
                  const SizedBox(height: 12),
                  Text(
                    'Zuri Health is a digital health platform connecting patients across sub-Saharan Africa with certified doctors via telemedicine. We operate in Rwanda, Kenya, and Nigeria with over 40,000 monthly active users.',
                    style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Industry details summary panel tags block array
                  Text('Enterprise Specifications', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.black)),
                  const SizedBox(height: 12),
                  _buildSpecificationRow('Sector', '🏥 HealthTech'),
                  _buildSpecificationRow('Location', '📍 Kigali, Rwanda'),
                  _buildSpecificationRow('Company Size', '👥 12 people'),
                  const SizedBox(height: 24),

                  Text('Domains We Work In', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.black)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: domains.map((d) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(12)),
                      child: Text(d, style: GoogleFonts.inter(color: const Color(0xFF137333), fontWeight: FontWeight.bold, fontSize: 13)),
                    )).toList(),
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

  Widget _buildHeaderMetricCell(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.black)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSpecificationRow(String category, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$category: ', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value, style: GoogleFonts.inter(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// Displays the interactive contextual choices menu bottom drawer overlay sheet
  void _showStartupSettingsBottomSheet(BuildContext context) {
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
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Startup Control Panel', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.black)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.storefront_outlined, color: Colors.black87),
                  title: Text('Edit Startup Profile Details', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StartupProfileSetupScreen(isEditing: true)));
                  },
                ),
                const Divider(height: 16),
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: Color(0xFFE53E3E)),
                  title: Text('Sign Out Venture Session', style: GoogleFonts.inter(fontWeight: FontWeight.black, fontSize: 15, color: const Color(0xFFE53E3E))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()), 
                      (route) => false,
                    );
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
