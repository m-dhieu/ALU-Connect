import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

/// Interactive configuration terminal used during both initial onboarding workflows
/// and later profile modification settings.
class ProfileSetupScreen extends StatefulWidget {
  final bool isEditing;

  const ProfileSetupScreen({super.key, this.isEditing = false});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String _selectedCampus = 'Kigali Campus';
  
  // Track selected tags reactively matching the mock data references
  final List<String> _availableSkills = ['React', 'Python', 'Flutter', 'Firebase', 'Figma', 'Node.js', 'Data Analysis', 'UX Research', 'Dart', 'UI Design'];
  final List<String> _selectedSkills = ['React', 'Python', 'Flutter', 'Firebase', 'Figma', 'Node.js', 'Data Analysis', 'UX Research'];

  final List<String> _availableInterests = ['HealthTech', 'EdTech', 'AgriTech', 'FinTech', 'E-Commerce', 'Logistics'];
  final List<String> _selectedInterests = ['HealthTech', 'EdTech', 'AgriTech', 'FinTech'];

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
        title: Text(
          widget.isEditing ? 'Edit Profile' : 'Setup Profile',
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEditing ? 'Update your ecosystem details' : 'Complete your profile',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              const SizedBox(height: 6),
              Text(
                'This information maps your profile onto relevant startup needs.',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 28),

              // Parameter Section 1: Campus Selection Dropdown
              Text(
                'ALU CAMPUS',
                style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: aluLightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCampus,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: <String>['Kigali Campus', 'Pamplemousses Campus (Mauritius)'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: 15, color: Colors.black87)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _selectedCampus = newValue!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Parameter Section 2: Technical Skills Matrix Selectors
              Text(
                'SELECT YOUR SKILLS',
                style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children: _availableSkills.map((skill) {
                  final bool isSelected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    selectedColor: aluDeepGreen.withValues(alpha: 0.15),
                    checkmarkColor: aluDeepGreen,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? aluDeepGreen : Colors.black87,
                    ),
                    backgroundColor: aluLightBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? aluDeepGreen : Colors.grey.shade200)),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Parameter Section 3: Industry Interests Domain Selectors
              Text(
                'AREAS OF INTEREST',
                style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 10.0,
                children: _availableInterests.map((interest) {
                  final bool isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE6F4EA),
                    checkmarkColor: const Color(0xFF137333),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xFF137333) : Colors.black87,
                    ),
                    backgroundColor: aluLightBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? const Color(0xFF137333) : Colors.grey.shade200)),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Action Commit Submission Controller Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.isEditing) {
                      Navigator.of(context).pop(); // Returns back to profile interface after updating variables
                    } else {
                      // Unwinds onboarding authorization sequences pushing live into dashboard
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aluDeepGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    widget.isEditing ? 'Save Changes' : 'Complete Setup →',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
