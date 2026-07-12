import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'startup_dashboard_screen.dart';

/// Form terminal used during startup creation or information adjustment.
class StartupProfileSetupScreen extends StatefulWidget {
  final bool isEditing;

  const StartupProfileSetupScreen({super.key, this.isEditing = false});

  @override
  State<StartupProfileSetupScreen> createState() => _StartupProfileSetupScreenState();
}

class _StartupProfileSetupScreenState extends State<StartupProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Text Entry Fields Listeners
  final _bioController = TextEditingController(text: 'Democratizing healthcare access across Africa');
  final _aboutController = TextEditingController(
    text: 'Zuri Health is a digital health platform connecting patients across sub-Saharan Africa with certified doctors via telemedicine. We operate in Rwanda, Kenya, and Nigeria with over 40,000 monthly active users.'
  );
  final _sizeController = TextEditingController(text: '12 people');
  
  String _selectedIndustry = '🏥 HealthTech';

  // Reactive tracks tag matrices selection map fields
  final List<String> _availableDomains = ['Engineering', 'Design', 'Marketing', 'Business', 'Research', 'Operations', 'Content', 'Community'];
  final List<String> _selectedDomains = ['Engineering', 'Design', 'Marketing'];

  @override
  void dispose() {
    _bioController.dispose();
    _aboutController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _bioController.text.trim().isNotEmpty && 
           _aboutController.text.trim().isNotEmpty && 
           _selectedDomains.isNotEmpty;
  }

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
          widget.isEditing ? 'Edit Startup Profile' : 'Setup Startup Profile',
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
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? 'Update business profiles' : 'Register your venture',
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.black, color: Colors.black),
                ),
                const SizedBox(height: 6),
                Text(
                  'Set up details visible to ALU students looking for opportunities.',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 28),

                // Industry Sector Selection Card Form Field
                _buildFormSectionLabel('INDUSTRY SECTOR'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: aluLightBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedIndustry,
                      isExpanded: true,
                      items: <String>['🏥 HealthTech', '🚜 AgriTech', '📚 EdTech', '💳 FinTech', '🚚 Logistics'].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val, style: GoogleFonts.inter(fontSize: 15, color: Colors.black87)),
                        );
                      }).toList(),
                      onChanged: (newValue) => setState(() => _selectedIndustry = newValue!),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Short Tagline/Bio Input Form Field
                _buildFormSectionLabel('STARTUP TAGLINE / ONE-LINER'),
                TextFormField(
                  controller: _bioController,
                  decoration: _buildInputDecoration('e.g. Building sustainable local climate solutions'),
                ),
                const SizedBox(height: 24),

                // Company Size Input Form Field
                _buildFormSectionLabel('COMPANY SIZE'),
                TextFormField(
                  controller: _sizeController,
                  decoration: _buildInputDecoration('e.g. 5 people'),
                ),
                const SizedBox(height: 24),

                // Comprehensive Long Description Text Form Field
                _buildFormSectionLabel('ABOUT THE STARTUP'),
                TextFormField(
                  controller: _aboutController,
                  maxLines: 4,
                  decoration: _buildInputDecoration('Provide a comprehensive background of your startup vision, products, and targets...'),
                ),
                const SizedBox(height: 24),

                // Target Fields Tracks Selection Tag Matrix Cloud
                _buildFormSectionLabel('OPERATIONAL DOMAINS'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 10.0,
                  children: _availableDomains.map((domain) {
                    final bool isSelected = _selectedDomains.contains(domain);
                    return FilterChip(
                      label: Text(domain),
                      selected: isSelected,
                      selectedColor: const Color(0xFFE6F4EA),
                      checkmarkColor: const Color(0xFF137333),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF137333) : Colors.black87,
                      ),
                      backgroundColor: aluLightBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isSelected ? const Color(0xFF137333) : Colors.grey.shade200),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedDomains.add(domain);
                          } else {
                            _selectedDomains.remove(domain);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),

                // Form Trigger Commit Execution Control Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid() 
                        ? () {
                            if (widget.isEditing) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const StartupDashboardScreen()),
                                (route) => false,
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aluDeepGreen,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      widget.isEditing ? 'Save Profile' : 'Complete Registration →',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0C4E33), width: 2)),
    );
  }
}
