import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/opportunity_data.dart'; // Import decoupled data layer file
import 'startup_profile_screen.dart';
import 'opportunity_details_screen.dart';

/// Main Dashboard container screen for ALU students.
/// Fetches mock items from models layer and filters layouts reactively.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedJobType = 'All';
  String _selectedCategory = 'Engineering'; // Set default highlights matching your exact screenshot view
  bool _isRemoteSelected = false;
  String _highlightedOpportunityId = '';

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluOrange = Color(0xFFF19E18);

    // Filter local lists using data arrays held inside the external repository file
    final List<Map<String, dynamic>> filteredOpportunities = OpportunityRepository.allOpportunities.where((opportunity) {
      final bool matchesCategory = _selectedCategory == 'All' || opportunity['category'] == _selectedCategory;
      final bool matchesJobType = _selectedJobType == 'All' || opportunity['jobType'] == _selectedJobType;
      final bool matchesRemote = !_isRemoteSelected || opportunity['workplaceSetting'] == 'Remote';
      return matchesCategory && matchesJobType && matchesRemote;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentIndex != 0 
          ? Center(child: Text('Screen Context Index: $_currentIndex', style: GoogleFonts.inter()))
          : Column(
              children: [
                // Top Header Segment Background
                Container(
                  color: aluDeepGreen,
                  padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0, bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Row Layout
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning,',
                                style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'm.dhieu',
                                    style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('👋', style: TextStyle(fontSize: 24)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Custom Search Box Widget
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          style: GoogleFonts.inter(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search roles, startups, skills...',
                            hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: 15),
                            prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 22),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Horizontal Job Type Filtering Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTopFilterChip('All', _selectedJobType == 'All', aluOrange, () {
                              setState(() => _selectedJobType = 'All');
                            }),
                            _buildTopFilterChip('Internship', _selectedJobType == 'Internship', aluOrange, () {
                              setState(() => _selectedJobType = 'Internship');
                            }),
                            _buildTopFilterChip('Part-time', _selectedJobType == 'Part-time', aluOrange, () {
                              setState(() => _selectedJobType = 'Part-time');
                            }),
                            _buildTopFilterChip('Project', _selectedJobType == 'Project', aluOrange, () {
                              setState(() => _selectedJobType = 'Project');
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Work Setting Filter Row
                      GestureDetector(
                        onTap: () => setState(() => _isRemoteSelected = !_isRemoteSelected),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isRemoteSelected ? aluOrange : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🌏', style: TextStyle(fontSize: 13)),
                              const SizedBox(width: 6),
                              Text(
                                'Remote',
                                style: GoogleFonts.inter(
                                  color: _isRemoteSelected ? Colors.black : Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Scrollable Dashboard Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        
                        // Categories List Bar Slider Frame
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              _buildCategoryChip('All', _selectedCategory == 'All', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'All');
                              }),
                              _buildCategoryChip('⚙️ Engineering', _selectedCategory == 'Engineering', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Engineering');
                              }),
                              _buildCategoryChip('🎨 Design', _selectedCategory == 'Design', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Design');
                              }),
                              _buildCategoryChip('📢 Marketing', _selectedCategory == 'Marketing', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Marketing');
                              }),
                              _buildCategoryChip('🔬 Research', _selectedCategory == 'Research', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Research');
                              }),
                              _buildCategoryChip('🔧 Operations', _selectedCategory == 'Operations', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Operations');
                              }),
                              _buildCategoryChip('✍️ Content', _selectedCategory == 'Content', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Content');
                              }),
                              _buildCategoryChip('🤝 Community', _selectedCategory == 'Community', aluDeepGreen, () {
                                setState(() => _selectedCategory = 'Community');
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section Title: ALU Startups
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'ALU Startups',
style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.extrabold, color: Colors.black),),),const SizedBox(height: 14),// Render Startups List out of the external Repository file reference arraysSizedBox(height: 95,child: ListView.builder(scrollDirection: Axis.horizontal,padding: const EdgeInsets.symmetric(horizontal: 18),itemCount: OpportunityRepository.aluStartups.length,itemBuilder: (context, index) {final startup = OpportunityRepository.aluStartups[index];
return Padding(padding: const EdgeInsets.symmetric(horizontal: 6.0),child: InkWell(onTap: () {final bool isFarmWave = startup['name'] == 'FarmWave';final String fullName = isFarmWave ? 'FarmWave' : (startup['name'] == 'Zuri' ? 'Zuri Health' : startup['name']);Navigator.of(context).push(MaterialPageRoute(builder: (context) => StartupProfileScreen(startupData: {'logoInit': startup['init'],'logoColor': startup['color'],'companyName': fullName,
'startupBio': isFarmWave? 'Precision agriculture intelligence for smallholder farmers': 'Democratizing healthcare access across Africa','fullAboutText': isFarmWave? "FarmWave uses satellite imagery, IoT sensors, and machine learning to deliver crop health insights directly to smallholder farmers via SMS.": "Zuri Health is a digital health platform connecting patients across sub-Saharan Africa with certified doctors via telemedicine.",'metaChips': isFarmWave? [' 🚜 AgriTech', '📍 Kigali', '📅 Est. 2024', '👥 9 people']: ['🏥 HealthTech', '📍 Kigali', '📅 Est. 2023', '👥 12 people'],'domains': isFarmWave? ['Engineering', 'Research', 'Business']: ['Engineering', 'Design', 'Marketing'],
'founders': isFarmWave? [{'name': 'Seun Adeyinka', 'role': 'Co-founder', 'init': 'SA'},{'name': 'Aisha Kamara', 'role': 'Co-founder', 'init': 'AK'}]: [{'name': 'Amara Diallo', 'role': 'Co-founder', 'init': 'AD'},{'name': 'Kwame Asante', 'role': 'Co-founder', 'init': 'KA'}],'openRoles': isFarmWave? [{'title': 'ML Research Intern','meta': 'Internship · 3 months · On-site',
'pay': 'RWF 90,000/month','spotsLeft': '1 spot left','daysLeft': '15d left','department': 'Research'}]: [{'title': 'Frontend Engineer Intern','meta': 'Internship · 3 months · On-site','pay': 'RWF 80,000/month','spotsLeft': '2 spots left','daysLeft': '14d left','department': 'Engineering'
}]},),),);},borderRadius: BorderRadius.circular(16),child: Column(children: [Stack(children: [Container(width: 56,
height: 56,decoration: BoxDecoration(color: startup['color'], borderRadius: BorderRadius.circular(16)),alignment: Alignment.center,child: Text(startup['init'],style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),),if (startup['verified'])Positioned(bottom: 0,right: 0,child: Container(padding: const EdgeInsets.all(2),decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
child: Icon(Icons.check_circle, color: aluOrange, size: 15),),),],),const SizedBox(height: 6),SizedBox(width: 65,child: Text(startup['name'],textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
),)],),),);},),),const SizedBox(height: 12),// Section Title: Dynamic Categorized Header Count (Matches Screenshot)Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0),child: Text(
'${filteredOpportunities.length} $_selectedCategory Opportunities',style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.extrabold, color: Colors.black),),),const SizedBox(height: 14),// Render out the dynamic filtered items map loopif (filteredOpportunities.isEmpty)Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),child: Center(child: Text('No matching opportunities in this track.',style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14, fontWeight:
FontWeight.w500),),),)else...filteredOpportunities.map((opp) => Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),child: _buildOpportunityCard(id: opp['id'],logoInit: opp['logoInit'],logoColor: opp['logoColor'],companyName: opp['companyName'],roleTitle: opp['roleTitle'],workplaceSetting: opp['workplaceSetting'],duration: opp['duration'],
jobType: opp['jobType'],department: opp['department'],stipend: opp['stipend'],spotsLeft: opp['spotsLeft'],daysLeft: opp['daysLeft'],primaryThemeColor: aluDeepGreen,),)),const SizedBox(height: 24),],),),),],
),// Bottom Global Navigation barbottomNavigationBar: BottomNavigationBar(currentIndex: _currentIndex,onTap: (index) => setState(() => _currentIndex = index),selectedItemColor: aluDeepGreen,unselectedItemColor: Colors.grey.shade400,selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.medium, fontSize: 12),showUnselectedLabels: true,type: BottomNavigationBarType.fixed,items: const [BottomNavigationBarItem(icon: Icon(Icons.explore_outlined, size: 24), activeIcon: Icon(Icons.explore), label: 'Explore'),
BottomNavigationBarItem(icon: Icon(Icons.description_outlined, size: 24), activeIcon: Icon(Icons.description), label: 'Applied'),BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 24), activeIcon: Icon(Icons.person), label: 'Profile'),],),);}/// Top header level job type filter chip helperWidget _buildTopFilterChip(String label, bool isSelected, Color activeColor, VoidCallback onTap) {return GestureDetector(onTap: onTap,child: Container(
margin: const EdgeInsets.only(right: 8),padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),decoration: BoxDecoration(color: isSelected ? activeColor : Colors.white.withOpacity(0.12),borderRadius: BorderRadius.circular(20),),child: Text(label,style: GoogleFonts.inter(color: isSelected ? Colors.black : Colors.white,fontSize: 13,fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,),),),
);}/// Inner body level category chip selection item helperWidget _buildCategoryChip(String label, bool isSelected, Color activeColor, VoidCallback onTap) {return GestureDetector(onTap: onTap,child: Container(margin: const EdgeInsets.only(right: 10),padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),decoration: BoxDecoration(color: isSelected ? activeColor : Colors.white,borderRadius: BorderRadius.circular(20),border: Border.all(color: isSelected ? activeColor : Colors.grey.shade200, width: 1),
),child: Text(label,style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.grey.shade700,fontSize: 13,fontWeight: FontWeight.bold,),),),);}/// Componentized opportunity card handler implementing dynamic navigation routesWidget _buildOpportunityCard({
required String id,required String logoInit,required Color logoColor,required String companyName,required String roleTitle,required String workplaceSetting,required String duration,required String jobType,required String department,required String stipend,required String spotsLeft,required String daysLeft,required Color primaryThemeColor,}) {
  final bool isHighlighted = _highlightedOpportunityId == id;return InkWell(onTap: () {setState(() {_highlightedOpportunityId = id;});Navigator.of(context).push(MaterialPageRoute(builder: (context) => OpportunityDetailsScreen(opportunityData: {'id': id,'logoInit': logoInit,'logoColor': logoColor,
  'companyName': companyName,'roleTitle': roleTitle,'workplaceSetting': workplaceSetting,'duration': duration,'jobType': jobType,'department': department,'stipend': stipend,'spotsLeft': spotsLeft,'daysLeft': daysLeft,'isApplied': id == 'opp_4', // Evaluates if card belongs to applied positions'aboutText': id == 'opp_1'? "Join Zuri Health's engineering squad to build and optimize responsive cross-platform layout components for patients inside our ecosystem.": "Help build and scale impactful digital operations within the marketplace.",},
  ),),);},borderRadius: BorderRadius.circular(16),child: Container(padding: const EdgeInsets.all(16),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16),border: Border.all(color: isHighlighted ? primaryThemeColor : Colors.grey.shade200, width: isHighlighted ? 2.0 : 1.0),boxShadow: [BoxShadow(color: isHighlighted ? primaryThemeColor.withOpacity(0.03) :
  Colors.black.withOpacity(0.015), blurRadius: 8, offset: const Offset(0, 2)),],),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Row(crossAxisAlignment: CrossAxisAlignment.start,children: [Container(width: 44,height: 44,decoration: BoxDecoration(color: logoColor, borderRadius: BorderRadius.circular(12)),alignment: Alignment.center,
  child: Text(logoInit, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),),const SizedBox(width: 12),Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Text(companyName, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),const SizedBox(height: 4),Text(roleTitle, style: GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),],),
  ),Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),child: Text(workplaceSetting, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),),],),const SizedBox(height: 12),Row(children: [
    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),decoration: BoxDecoration(color: primaryThemeColor, borderRadius: BorderRadius.circular(6)),child: Text(jobType, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),),const SizedBox(width: 6),Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),child: Text(department, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
    ),const SizedBox(width: 6),Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),child: Text(duration, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),),],),const SizedBox(height: 10),Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(6)),child: Text(stipend, style: GoogleFonts.inter(color: const Color(0xFFC2410C), fontSize: 12, fontWeight: FontWeight.bold)),),const SizedBox(height: 12),Divider(color: Colors.grey.shade100, height: 1),const SizedBox(height: 8),Row(mainAxisAlignment: MainAxisAlignment.between,children: [Text(spotsLeft, style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w500)),Text(daysLeft, style: GoogleFonts.inter(color: const Color(0xFFC2410C), fontSize: 12, fontWeight: FontWeight.bold)),
    ],),],),),);}}
    

---

### File 3: Link Screens in the Shell Layer
`lib/screens/home_screen.dart`

To enable the bottom navigation bar switches, open your `lib/screens/home_screen.dart` file and update its state controller to swap view screens based on the `_currentIndex` selection:

```dart
// At the top of lib/screens/home_screen.dart add the import parameter:
import 'applied_screen.dart';

// Locate your build widget block and modify the Scaffold setup to switch screens reactively:
@override
Widget build(BuildContext context) {
  const Color aluDeepGreen = Color(0xFF0C4E33);
  const Color aluOrange = Color(0xFFF19E18);

  // Array mapping targeted workspace tabs cleanly
  final List<Widget> bottomNavigationScreens = [
    // Index 0 represents the main Explore Feed View core layout code
    const SizedBox.shrink(), // Rendered directly inside column below
    const AppliedScreen(),   // Index 1 switches cleanly to tracker screen
    const Center(child: Text('Profile Screen Layer Coming Soon')), // Index 2 placeholder
  ];

  return Scaffold(
    backgroundColor: Colors.white,
    // Evaluate if shell should frame standard explore components or selected navigation index targets
    body: _currentIndex != 0 
        ? bottomNavigationScreens[_currentIndex]
        : Column(
          // Keep your entire existing explore column widget code EXACTLY as it is written!
            // Do not delete anything from the children array here!
          ),
          
    // Keep your existing bottomNavigationBar configuration exactly identical below...