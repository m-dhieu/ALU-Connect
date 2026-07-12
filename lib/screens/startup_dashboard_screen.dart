import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'opportunity_details_screen.dart';
import 'post_opportunity_screen.dart';
import 'startup_my_profile_screen.dart';

/// Central analytical workspace for verified ALU ecosystem startups.
/// Enables position lifecycle monitoring and inbound student application review.
class StartupDashboardScreen extends StatefulWidget {
  const StartupDashboardScreen({super.key});

  @override
  State<StartupDashboardScreen> createState() => _StartupDashboardScreenState();
}

class _StartupDashboardScreenState extends State<StartupDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Brand palettes matching the dynamic Zuri Health presentation profile rules
    const Color companyThemeColor = Color(0xFF0C4E33);
    const Color aluDeepGreen = Color(0xFF0C4E33);

    // Context views array mapping out structural startup menu options
    final List<Widget> startupTabs = [
      const SizedBox.shrink(), // Rendered directly inside column below
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
                // Top Section: Rich Brand Analytical Hub Banner
                Container(
                  color: companyThemeColor,
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0, bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subheading Dashboard Context Tag
                      Text(
                        'Startup Dashboard',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Core Entity Label Typography
                      Text(
                        'Zuri Health',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Horizontal Operations KPI Metrics Summary Matrix
                      Row(
                        children: [
                          _buildUpperSummaryMetricCard('2', 'Open Roles'),
                          const SizedBox(width: 10),
                          _buildUpperSummaryMetricCard('4', 'Applicants'),
                          const SizedBox(width: 10),
                          _buildUpperSummaryMetricCard('1', 'Interviews'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Dashboard Body Context Viewport
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Primary Workflow Call-To-Action Element: Post an Opportunity
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

                        // Section Heading Block: Active Listings
                        Text(
                          'Active Listings',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Position Slot Card 1
                        _buildActiveListingTrackCard(
                          context,
                          id: 'opp_1',
                          positionTitle: 'Frontend Engineer Intern',
                          metaDetails: 'Internship · 2 spots',
                          expiryDateString: 'Closes Jul 25',
                          companyThemeColor: companyThemeColor,
                        ),
                        const SizedBox(height: 12),

                        // Position Slot Card 2
                        _buildActiveListingTrackCard(
                          context,
                          id: 'opp_2',
                          positionTitle: 'Product Design Intern',
                          metaDetails: 'Internship · 1 spot',
                          expiryDateString: 'Closes Jul 28',
                          companyThemeColor: companyThemeColor,
                        ),
                        const SizedBox(height: 28),

                        // Section Heading Block: Recent Applicants
                        Text(
                          'Recent Applicants',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Applicant Vector Profile 1
                        _buildApplicantStatusRow(
                          studentName: 'Amara Diallo',
                          targetRole: 'Frontend Engineer Intern',
                          profileInit: 'AD',
                          statusBadgeLabel: 'Shortlisted',
                          isShortlisted: true,
                        ),
                        const SizedBox(height: 12),

                        // Applicant Vector Profile 2
                        _buildApplicantStatusRow(
                          studentName: 'Kwame Asante',
                          targetRole: 'Frontend Engineer Intern',
                          profileInit: 'KA',
                          statusBadgeLabel: 'Under Review',
                          isShortlisted: false,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),

      // Local Startup Workspace Navigation Frame Base Shell
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

  /// Upper header panel operational micro tile matrix builder
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

  /// Factory helper structuring active internship position cards cleanly.
  /// Seamlessly redirects startup operators to view full opportunity specifications.
  Widget _buildActiveListingTrackCard(
    BuildContext context, {
    required String id,
    required String positionTitle,
    required String metaDetails,
    required String expiryDateString,
    required Color companyThemeColor,
  }) {
    return InkWell(
      onTap: () {
        // Explicitly reuse the same high-utility Opportunity Details view layer
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OpportunityDetailsScreen(
              opportunityData: {
                'id': id,
                'logoInit': 'ZH',
                'logoColor': companyThemeColor,
                'companyName': 'Zuri Health',
                'roleTitle': positionTitle,
                'workplaceSetting': 'On-site',
                'duration': metaDetails.contains('3 months') ? '3 months' : '6 months',
                'jobType': 'Internship',
                'department': positionTitle.contains('Design') ? 'Design' : 'Engineering',
                'stipend': positionTitle.contains('Design') ? 'RWF 70,000/mo' : 'RWF 80,000/mo',
                'spotsLeft': metaDetails.contains('2 spots') ? '2 spots left' : '1 spot left',
                'daysLeft': '14d left',
                // Special flag telling the screen to hide student application sheets
                'isApplied': true,
                'aboutText': positionTitle.contains('Design')
                    ? "Help shape the user experience of Africa's fastest-growing digital health platform. You'll own end-to-end design for two upcoming features and conduct user research with patients and doctors."
                    : "Join Zuri Health's engineering squad to build and optimize responsive cross-platform layout components for patients inside our ecosystem.",
              },
            ),
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
                      Text(
                        positionTitle,
                        style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900),
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
                    metaDetails,
                    style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    expiryDateString,
                    style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Text(
              'View details →',
              style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom list component displaying student submission vectors and status badge labels
  Widget _buildApplicantStatusRow({
    required String studentName,
    required String targetRole,
    required String profileInit,
    required String statusBadgeLabel,
    required bool isShortlisted,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: Color(0xFFE6F4EA), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(profileInit, style: GoogleFonts.inter(color: const Color(0xFF137333), fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName, style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(targetRole, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isShortlisted ? const Color(0xFFE8F0FE) : const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusBadgeLabel,
              style: GoogleFonts.inter(
                color: isShortlisted ? const Color(0xFF1A73E8) : Colors.grey.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
