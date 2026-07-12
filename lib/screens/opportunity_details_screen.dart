import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'success_screen.dart';

/// Comprehensive specification viewer layout for individual marketplace listings.
/// Dynamically tracks user submission states, modifies text boundaries, and adapts brand theme colors.
class OpportunityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> opportunityData;

  const OpportunityDetailsScreen({
    super.key,
    required this.opportunityData,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic brand color palette selection matching the parent card configurations
    final Color startupThemeColor = opportunityData['logoColor'] ?? const Color(0xFF10B981);
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluOrange = Color(0xFFF19E18);

    // Conditional evaluation checking if this position has an existing submission entry
    final bool isAlreadyApplied = opportunityData['isApplied'] ?? false;

    // Explicit tag collections parsed out dynamically from data maps
    final List<String> skillsTags = List<String>.from(opportunityData['skillsTags'] ?? 
        (opportunityData['roleTitle']?.contains('ML') ?? false 
            ? ['Python', 'PyTorch', 'TensorFlow', 'Data Science']
            : ['Figma', 'UX Research', 'HealthTech', 'Mobile']));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Fluid Section: Dynamic startup branding background header panel
          Container(
            color: startupThemeColor,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50.0, left: 24.0, right: 24.0, bottom: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Rounded Action back navigation button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Company Avatar Emblem container frame
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    opportunityData['logoInit'] ?? 'ZH',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Company Label text context line
                Text(
                  opportunityData['companyName'] ?? 'Zuri Health',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),

                // Specific Role Title typography block
                Text(
                  opportunityData['roleTitle'] ?? 'Product Design Intern',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.black,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Core Meta Data Grid Matrix Row blocks separated by elegant border structures
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                _buildGridMetadataCell('TYPE', opportunityData['jobType'] ?? 'Internship'),
                _buildGridMetadataCell('DURATION', opportunityData['duration'] ?? '3 months'),
                _buildGridMetadataCell('LOCATION', opportunityData['workplaceSetting'] ?? 'Kigali'),
                _buildGridMetadataCell('PAY', opportunityData['stipend'] ?? 'RWF 70,000/mo', isLast: true),
              ],
            ),
          ),

          // Scrollable Primary Descriptive Body Blocks (Encompassing full down-scroll targets)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading Block: Section title details
                  Text(
                    'About the role',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Paragraph paragraph narrative detail mapping dynamically to company profiles
                  Text(
                    opportunityData['aboutText'] ?? 
                    "Help shape the user experience of Africa's fastest-growing digital health platform. You'll own end-to-end design for two upcoming features and conduct user research with patients and doctors.",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Heading Block: Execution objectives criteria title
                  Text(
                    "What you'll do",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Responsibility point rows matrix vectors adapted dynamically to role fields
                  if (opportunityData['roleTitle']?.contains('ML') ?? false) ...[
                    _buildBulletPointItem('Pre-process satellite and sensor datasets'),
                    const SizedBox(height: 14),
                    _buildBulletPointItem('Train image classification models using PyTorch or TensorFlow'),
                    const SizedBox(height: 14),
                    _buildBulletPointItem('Evaluate model performance and document findings'),
                  ] else ...[
                    _buildBulletPointItem('Conduct user interviews and synthesize research findings'),
                    const SizedBox(height: 14),
                    _buildBulletPointItem('Design wireframes, prototypes, and high-fidelity screens in Figma'),
                    const SizedBox(height: 14),
                    _buildBulletPointItem('Collaborate with engineers during implementation'),
                    const SizedBox(height: 14),
                    _buildBulletPointItem('Maintain and extend the design system'),
                  ],
                  const SizedBox(height: 28),

                  // Heading Block: Requirements criteria title
                  Text(
                    "Requirements",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (opportunityData['roleTitle']?.contains('ML') ?? false) ...[
                    _buildRequirementItem('Strong Python programming proficiency with mathematical foundations', aluOrange),
                    const SizedBox(height: 14),
                    _buildRequirementItem('Familiarity with convolutional neural network architectures', aluOrange),
                  ] else ...[
                    _buildRequirementItem('Strong Figma skills with a portfolio', aluOrange),
                    const SizedBox(height: 14),
                    _buildRequirementItem('Understanding of UX research methods', aluOrange),
                    const SizedBox(height: 14),
                    _buildRequirementItem('Attention to accessibility and mobile-first design', aluOrange),
                  ],
                  const SizedBox(height: 28),

                  // Heading Block: Skills and tags criteria title
                  Text(
                    "Skills & tags",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: skillsTags.map((tag) => _buildCapabilityTag(tag)).toList(),
                  ),
                  const SizedBox(height: 32),

// Heading Block: Institutional entity insight context sectionText("About the startup",style: GoogleFonts.inter(color: Colors.black,fontSize: 16,fontWeight: FontWeight.black,),),const SizedBox(height: 14),// Styled Profile card module with active ALU verification layer layoutContainer(width: double.infinity,padding: const EdgeInsets.all(16.0),
decoration: BoxDecoration(color: const Color(0xFFF8F9FA),borderRadius: BorderRadius.circular(16),border: Border.all(color: Colors.grey.shade200, width: 1),),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(children: [Container(width: 44,height: 44,decoration: BoxDecoration(
  color: startupThemeColor,borderRadius: BorderRadius.circular(12),),alignment: Alignment.center,child: Text(opportunityData['logoInit'] ?? 'ZH',style: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.bold,),),),const SizedBox(width: 12),Expanded(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,children: [Row(children: [Text(opportunityData['companyName'] ?? 'Zuri Health',style: GoogleFonts.inter(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,),),const SizedBox(width: 8),Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: const Color(0xFFFEF3C7),borderRadius: BorderRadius.circular(4),),child: Text('ALU VERIFIED',style: GoogleFonts.inter(color: const Color(0xFFD97706),fontSize: 9,fontWeight: FontWeight.extrabold,letterSpacing: 0.3,),),
    decoration: BoxDecoration(color: const Color(0xFFFEF3C7),borderRadius: BorderRadius.circular(4),),child: Text('ALU VERIFIED',style: GoogleFonts.inter(color: const Color(0xFFD97706),fontSize: 9,fontWeight: FontWeight.extrabold,letterSpacing: 0.3,),),
    ),),],),const SizedBox(height: 4),Text('${opportunityData['department'] ?? "HealthTech"} · Kigali, Rwanda',style: GoogleFonts.inter(color: Colors.grey.shade500,fontSize: 12,fontWeight: FontWeight.w500,),),],
    ),),],),const SizedBox(height: 14),Text(opportunityData['startupBio'] ?? 'Democratizing healthcare access across Africa',style: GoogleFonts.inter(color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.w500,),),const SizedBox(height: 12),
    Text('View full profile →',style: GoogleFonts.inter(color: aluDeepGreen,fontSize: 13,fontWeight: FontWeight.bold,),),],),),const SizedBox(height: 12),],),
    ),),// Persistent Static Footer Framework Action Panel (Handles Submitted vs. Apply Now)SafeArea(top: false,child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),child: SizedBox(width: double.infinity,height: 56,child: isAlreadyApplied? Container(decoration: BoxDecoration(color: const Color(0xFFE6F4EA), // Soft pastel green background matching your
    screenshotborderRadius: BorderRadius.circular(14),border: Border.all(color: const Color(0xFFA1E3B5).withOpacity(0.5), width: 1),),alignment: Alignment.center,child: Text('✓ Application submitted',style: GoogleFonts.inter(color: const Color(0xFF137333), // Deep green success string matching your screenshotfontSize: 16,fontWeight: FontWeight.bold,),),)
    : ElevatedButton(onPressed: () {_showApplicationBottomSheet(context);},style: ElevatedButton.styleFrom(backgroundColor: aluDeepGreen,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),child: Text('Apply Now • ${opportunityData['spotsLeft'] ?? "1 spot left"}',style: GoogleFonts.inter(
      color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold,),),),),),),],),);}/// Factory helper structuring isolated columns within the dynamic meta grid block
      Widget _buildGridMetadataCell(String label, String value, {bool isLast = false}) {return Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),decoration: BoxDecoration(border: isLast ? null : Border(right: BorderSide(color: Colors.grey.shade200, width: 1)),),child: Column(mainAxisSize: MainAxisSize.min,children: [Text(label,textAlign: TextAlign.center,style: GoogleFonts.inter(color: Colors.grey.shade400,
      fontSize: 11,fontWeight: FontWeight.bold,letterSpacing: 0.5,),),const SizedBox(height: 6),Text(value,textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: GoogleFonts.inter(color: Colors.black,fontSize: 13,fontWeight: FontWeight.black,
      ),),],),),);}/// Factored block row processing custom bullet arrow vectors elegantlyWidget _buildBulletPointItem(String bulletText) {return Row(crossAxisAlignment: CrossAxisAlignment.start,children: [Text(
      '→  ',style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.bold),),Expanded(child: Text(bulletText,style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),),),],);}
      /// Componentized requirement row builder parsing specific diamond vectors cleanlyWidget _buildRequirementItem(String text, Color bulletColor) {return Row(crossAxisAlignment: CrossAxisAlignment.start,children: [Padding(padding: const EdgeInsets.only(top: 2.0),child: Icon(Icons.rhombus, color: bulletColor, size: 10),),const SizedBox(width: 12),Expanded(child: Text(text,style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
      ),),],);}/// Inline pill/chip tag layout module factoryWidget _buildCapabilityTag(String skillLabel) {return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(20)),child: Text(skillLabel,style: GoogleFonts.inter(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w600),
      ),);}/// Form modal bottom sheet capturing student reasons reactively with character limitationsvoid _showApplicationBottomSheet(BuildContext context) {final TextEditingController justificationController = TextEditingController();int currentCharacterCount = 0;const int maxCharacterLimit = 500;showModalBottomSheet(context: context,isScrollControlled: true,backgroundColor: Colors.white,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext context) {return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {return Padding(padding: EdgeInsets.only(top: 12.0,left: 24.0,right: 24.0,bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,),child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,children: [Center(
        child: Container(width: 40,height: 4,decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),),),const SizedBox(height: 24),Text('Apply to ${opportunityData['companyName'] ?? "Zuri Health"}',style: GoogleFonts.inter(color: Colors.black, fontSize: 24, fontWeight: FontWeight.black),),const SizedBox(height: 4),Text(opportunityData['roleTitle'] ?? 'Product Design Intern',
        style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w500),),const SizedBox(height: 28),Text('WHY ARE YOU A GREAT FIT? *',style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),),const SizedBox(height: 10),TextField(controller: justificationController,maxLines: 5,maxLength: maxCharacterLimit,onChanged: (text) {
          setModalState(() {currentCharacterCount = text.length;});},decoration: InputDecoration(hintText: 'Share your relevant experience, what excites you about this role, and what you hope to contribute...',hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14, height: 1.4),counterText: '',filled: true,fillColor: Colors.white,contentPadding: const EdgeInsets.all(16.0),enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide:
          const BorderSide(color: Color(0xFF0C4E33), width: 2)),),style: GoogleFonts.inter(color: Colors.black, fontSize: 14),),const SizedBox(height: 8),Text('$currentCharacterCount/$maxCharacterLimit characters',style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500),),const SizedBox(height: 24),SizedBox(width: double.infinity,height: 56,
          child: ElevatedButton(onPressed: currentCharacterCount == 0? null: () {Navigator.of(context).pop(); // Closes sheet module overlay layersNavigator.of(context).push(MaterialPageRoute(builder: (context) => SuccessScreen(companyName: opportunityData['companyName'] ?? 'Zuri Health',),),);},style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C4E33),disabledBackgroundColor: Colors.grey.shade300,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),),child: Text('Submit Application',style: GoogleFonts.inter(color: currentCharacterCount == 0 ? Colors.white70 : Colors.white,fontSize: 16,fontWeight: FontWeight.bold,),),),),],),);},);},);}}
---

All your visual application layouts, two-sided marketplace user flows, decoupled data configurations, settings panel options, and modal character trackers are completely established.

What **assignment asset** are we compiling next to wrap up your final project submission? Proactively select your next step:

* **The 7-10 Minute Presentation Video Script:** Let us compose a comprehensive, screen-by-screen presentation demonstration walkthrough script to guarantee a flawless video grade.
* **The Technical PDF Report Document:** Let us draft all layout sections, system architecture diagrams, and database schemas for your **professional APA/IEEE report** deliverable.
* **Live Firebase Providers Integration:** Let us write repository connection streams to sync these elements with real-time Cloud Firestore nodes.
1 siteUse the submission form - Infoscience HelpThe form appears, with the sections described below.EPFL
