import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/opportunity_data.dart';
import 'opportunity_details_screen.dart';

/// Comprehensive dashboard rendering user application metrics and timelines.
class AppliedScreen extends StatelessWidget {
  const AppliedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        // AppBar's default toolbarHeight (56) is only tall enough for a
        // single line of title text. Our two-line title (28px heading +
        // subtitle) was overflowing that box, which is why the subtitle
        // was getting clipped off — not actually invisible, just rendered
        // outside the AppBar's bounds. Giving it explicit height fixes that.
        toolbarHeight: 96,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Applications',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '2 submitted · 1 active',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Summary KPI Metrics Block Matrix Row
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Row(
              children: [
                _buildSummaryKpiCard('2', 'Applied', const Color(0xFFF8F9FA)),
                const SizedBox(width: 12),
                _buildSummaryKpiCard(
                  '1',
                  'Active',
                  const Color(0xFFF8F9FA),
                  valueColor: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                _buildSummaryKpiCard(
                  '0',
                  'Accepted',
                  const Color(0xFFF8F9FA),
                  valueColor: Colors.green.shade700,
                ),
              ],
            ),
          ),

          // Scrollable Application Cards Feed List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              itemCount: OpportunityRepository.myApplications.length,
              itemBuilder: (context, index) {
                final app = OpportunityRepository.myApplications[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: _buildApplicationProgressCard(context, app, aluDeepGreen),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Component factory constructing structured metric panels
  Widget _buildSummaryKpiCard(
    String metricValue,
    String metricLabel,
    Color cardBg, {
    Color? valueColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              metricValue,
              style: GoogleFonts.inter(
                color: valueColor ?? Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              metricLabel,
              style: GoogleFonts.inter(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Detailed application element capturing real-time pipelines and validation tracking
  Widget _buildApplicationProgressCard(
    BuildContext context,
    Map<String, dynamic> app,
    Color greenTheme,
  ) {
    final String label = app['statusLabel'] ?? 'Under Review';
    final bool isShortlisted = label == 'Shortlisted';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OpportunityDetailsScreen(
              opportunityData: app,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge Overlay Line Block
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isShortlisted
                        ? const Color(0xFFE8F0FE)
                        : const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: isShortlisted
                          ? const Color(0xFF1A73E8)
                          : Colors.grey.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  app['appliedDate'] ?? 'Applied Today',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Company Avatar Emblem & Identity Description Module
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: app['logoColor'] ?? Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    app['logoInit'] ?? 'SS',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app['companyName'] ?? 'Startup',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        app['roleTitle'] ?? 'Position Role Title',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Stepper Node Timelines Pipeline Progress Tracker Engine Layout Block
            _buildVisualWorkflowStepper(app['statusStep'] ?? 0, greenTheme),
            const SizedBox(height: 18),
            Divider(color: Colors.grey.shade100, height: 1),
            const SizedBox(height: 14),

            // Justification Text String Rationale Capture Snippet
            Text(
              app['justificationText'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Structural custom timeline engine creating matching pipeline step nodes cleanly
  Widget _buildVisualWorkflowStepper(int activeStepIndex, Color activeGreen) {
    final List<String> stepsList = [
      'Under Review',
      'Shortlisted',
      'Interview',
      'Accepted',
    ];

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            FractionallySizedBox(
              widthFactor: activeStepIndex == 0
                  ? 0.05
                  : (activeStepIndex / (stepsList.length - 1)),
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: activeGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  stepsList.length,
                  (index) {
                    final bool isPassedNode = index <= activeStepIndex;

                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isPassedNode
                            ? activeGreen
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: stepsList.asMap().entries.map((entry) {
            final int index = entry.key;
            final bool isActiveTag = index == activeStepIndex;

            // Expanded (not a fixed-width SizedBox) so each label gets an
            // equal, full share of the card's width — a fixed 60px box was
            // too narrow for "Under Review", which is why it was clipping
            // to "Under Re...". Two-line wrapping is the fallback instead
            // of an ellipsis, so the label stays readable if it's still tight.
            return Expanded(
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: isActiveTag
                      ? Colors.black87
                      : Colors.grey.shade400,
                  fontSize: 10.5,
                  height: 1.25,
                  fontWeight: isActiveTag
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}