import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/opportunity.dart';
import '../providers/auth_providers.dart';
import '../providers/opportunity_providers.dart';
import 'opportunity_details_screen.dart';
import 'post_opportunity_screen.dart';
import 'startup_my_profile_screen.dart';

// show startup dashboard & application reviews
class StartupDashboardScreen extends ConsumerStatefulWidget {
  const StartupDashboardScreen({super.key});

  @override
  ConsumerState<StartupDashboardScreen> createState() => _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends ConsumerState<StartupDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);

    // show signed-in founder name from Firestore
    final profile = ref.watch(currentUserProfileProvider).value;
    final String founderDisplayName = profile?.fullName ?? 'Your venture';

    final myOpportunities = ref.watch(myOpportunitiesProvider).value ?? const <Opportunity>[];

    final List<Widget> startupTabs = [
      const SizedBox.shrink(), 
      Center(child: Text('Create Listing Terminal', style: GoogleFonts.inter())),
      const StartupMyProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentIndex != 0
          ? startupTabs[_currentIndex]
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // analytical hub banner
                Container(
                  color: aluDeepGreen,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0, bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Startup Dashboard',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        founderDisplayName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // show Firestore job postings
                      // keep application counts empty until data exists
                      Row(
                        children: [
                          _buildUpperSummaryMetricCard('${myOpportunities.length}', 'Open Roles'),
                          const SizedBox(width: 10),
                          _buildUpperSummaryMetricCard('0', 'Applicants'),
                          const SizedBox(width: 10),
                          _buildUpperSummaryMetricCard('0', 'Interviews'),
                        ],
                      ),
                    ],
                  ),
                ),

                // main dashboard body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // post an opportunity
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const PostOpportunityScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: aluDeepGreen,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Post an opportunity',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Find your next team member',
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        Text(
                          'Active Listings',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (myOpportunities.isEmpty)
                          _buildEmptyState(
                            icon: Icons.work_outline,
                            message: "You haven't posted any opportunities yet.",
                          )
                        else
                          ...myOpportunities.map((opportunity) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildActiveListingTrackCard(context, opportunity),
                              )),
                        const SizedBox(height: 28),

                        Text(
                          'Recent Applicants',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildEmptyState(
                          icon: Icons.people_outline,
                          message: 'Applicants will show up here once students start applying.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PostOpportunityScreen()),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        selectedItemColor: aluDeepGreen,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined, size: 22), activeIcon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 22), activeIcon: Icon(Icons.add_box), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined, size: 22), activeIcon: Icon(Icons.business_center), label: 'Profile'),
        ],
      ),
    );
  }

  // create header micro metric tiles
  Widget _buildUpperSummaryMetricCard(String numericalValue, String informationalLabel) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              numericalValue,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 2),
            Text(
              informationalLabel,
              style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // show founder opportunity card using Firestore data
  // reuse student opportunity view for consistency
  Widget _buildActiveListingTrackCard(BuildContext context, Opportunity opportunity) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OpportunityDetailsScreen(opportunityData: opportunity.toDisplayMap()),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          opportunity.roleTitle,
                          style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          'Active',
                          style: GoogleFonts.inter(color: const Color(0xFF137333), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${opportunity.jobType} · ${opportunity.spotsLeftLabel}',
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    opportunity.daysLeftLabel,
                    style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostOpportunityScreen(existingOpportunity: opportunity),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Edit',
                          style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'View details →',
                  style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 28),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
