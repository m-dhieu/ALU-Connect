import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/opportunity.dart';
import '../providers/auth_providers.dart';
import '../providers/opportunity_providers.dart';
import 'post_opportunity_screen.dart';
import 'startup_profile_setup_screen.dart';
import 'notification_screen.dart';

// show startup stats & profile actions
class StartupMyProfileScreen extends ConsumerWidget {
  const StartupMyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluOrange = Color(0xFFF19E18);

    final profile = ref.watch(currentUserProfileProvider).value;
    final String founderName = profile?.fullName ?? 'Your venture';
    final bool isVerified = profile?.isVerifiedStartup ?? false;
    final List<Opportunity> myOpportunities = ref.watch(myOpportunitiesProvider).value ?? const [];
    final String initials = founderName
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: aluDeepGreen,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60.0, bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                      onPressed: () => _showStartupSettingsBottomSheet(context, ref),
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

                // show startup emblem badge
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials.isEmpty ? '?' : initials,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 14),

                // show startup name & verification badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      founderName,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: isVerified ? aluOrange : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isVerified ? 'ALU VERIFIED' : 'PENDING VERIFICATION',
                        style: GoogleFonts.inter(color: isVerified ? Colors.black : Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // show founder posting metrics from Firestore
                // keep application metrics empty until data exists
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderMetricCell('${myOpportunities.length}', 'Active Roles'),
                    _buildHeaderMetricCell('0', 'Total Apps'),
                    _buildHeaderMetricCell('0', 'Interviews'),
                  ],
                ),
              ],
            ),
          ),

          // scrollable description content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myOpportunities.isNotEmpty) ...[
                    Text('Active Roles', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...myOpportunities.map((o) => _buildActiveRoleRow(context, o)),
                    const SizedBox(height: 24),

                    Text('Recent Updates', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...myOpportunities.take(3).map((o) => _buildRecentUpdateRow(o)),
                    const SizedBox(height: 24),
                  ],

                  Text('About', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  if (profile == null || profile.about.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.storefront_outlined, color: Colors.grey.shade400, size: 26),
                          const SizedBox(height: 10),
                          Text(
                            "You haven't added a company bio or specifications yet.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const StartupProfileSetupScreen(isEditing: true)),
                              );
                            },
                            child: Text(
                              'Complete your profile',
                              style: GoogleFonts.inter(color: aluDeepGreen, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    if (profile.tagline.isNotEmpty) ...[
                      Text(
                        profile.tagline,
                        style: GoogleFonts.inter(color: Colors.grey.shade600, fontStyle: FontStyle.italic, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      profile.about,
                      style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    Text('Enterprise Specifications', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    if (profile.industry.isNotEmpty) _buildSpecificationRow('Sector', profile.industry),
                    if (profile.companySize.isNotEmpty) _buildSpecificationRow('Company Size', '👥 ${profile.companySize}'),
                    const SizedBox(height: 24),

                    if (profile.domains.isNotEmpty) ...[
                      Text('Domains We Work In', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 10.0,
                        children: profile.domains.map((d) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(12)),
                          child: Text(d, style: GoogleFonts.inter(color: const Color(0xFF137333), fontWeight: FontWeight.bold, fontSize: 13)),
                        )).toList(),
                      ),
                    ],
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // show editable founder opportunity list
  Widget _buildActiveRoleRow(BuildContext context, Opportunity opportunity) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostOpportunityScreen(existingOpportunity: opportunity),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(opportunity.roleTitle, style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    '${opportunity.jobType} · ${opportunity.spotsLeftLabel}',
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit_outlined, size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  // show recent posting activity updates
  Widget _buildRecentUpdateRow(Opportunity opportunity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.campaign_outlined, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '"${opportunity.roleTitle}" is live · ${opportunity.daysLeftLabel}',
              style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
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

  Widget _buildHeaderMetricCell(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // show profile options bottom sheet
  void _showStartupSettingsBottomSheet(BuildContext context, WidgetRef ref) {
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
                  child: Text('Startup Control Panel', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.storefront_outlined, color: Colors.black87),
                  title: Text('Edit Startup Profile Details', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StartupProfileSetupScreen(isEditing: true)));
                  },
                ),
                const Divider(height: 16),
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: Color(0xFFE53E3E)),
                  title: Text('Sign Out Venture Session', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 15, color: const Color(0xFFE53E3E))),
                  onTap: () {
                    Navigator.of(context).pop();
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
