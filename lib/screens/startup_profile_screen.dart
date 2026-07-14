import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'opportunity_details_screen.dart';

// public startup profile view
class StartupProfileScreen extends StatelessWidget {
  final Map<String, dynamic> startupData;

  const StartupProfileScreen({super.key, required this.startupData});

  @override
  Widget build(BuildContext context) {
    const Color aluOrange = Color(0xFFF19E18);

    final Color themeColor = startupData['logoColor'] ?? const Color(0xFF0C4E33);
    final String logoInit = startupData['logoInit'] ?? '';
    final String companyName = startupData['companyName'] ?? '';
    final String startupBio = startupData['startupBio'] ?? '';
    final String fullAboutText = startupData['fullAboutText'] ?? '';
    final List<String> metaChips = List<String>.from(startupData['metaChips'] ?? []);
    final List<String> domains = List<String>.from(startupData['domains'] ?? []);
    final List<Map<String, dynamic>> founders = List<Map<String, dynamic>>.from(startupData['founders'] ?? []);
    final List<Map<String, dynamic>> openRoles = List<Map<String, dynamic>>.from(startupData['openRoles'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: themeColor,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60.0, bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    logoInit,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      companyName,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: aluOrange, borderRadius: BorderRadius.circular(4)),
                      child: Text('ALU VERIFIED', style: GoogleFonts.inter(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  startupBio,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Text(
                    fullAboutText,
                    style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 10.0,
                    children: metaChips
                        .map((chip) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(8)),
                              child: Text(chip, style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  if (domains.isNotEmpty) ...[
                    Text('Domains We Work In', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 10.0,
                      children: domains
                          .map((d) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(12)),
                                child: Text(d, style: GoogleFonts.inter(color: const Color(0xFF137333), fontWeight: FontWeight.bold, fontSize: 13)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (founders.isNotEmpty) ...[
                    Text('Founders', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...founders.map((founder) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(color: Color(0xFFE6F4EA), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(founder['init'] ?? '', style: GoogleFonts.inter(color: const Color(0xFF137333), fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(founder['name'] ?? '', style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text(founder['role'] ?? '', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],

                  if (openRoles.isNotEmpty) ...[
                    Text('Open Roles', style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...openRoles.map((role) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => OpportunityDetailsScreen(
                                    opportunityData: {
                                      'logoInit': logoInit,
                                      'logoColor': themeColor,
                                      'companyName': companyName,
                                      'roleTitle': role['title'],
                                      'department': role['department'],
                                      'stipend': role['pay'],
                                      'spotsLeft': role['spotsLeft'],
                                      'daysLeft': role['daysLeft'],
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(role['title'] ?? '', style: GoogleFonts.inter(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 6),
                                  Text(role['meta'] ?? '', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 6),
                                  Text(role['pay'] ?? '', style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
