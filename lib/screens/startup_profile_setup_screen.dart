import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';
import 'startup_dashboard_screen.dart';

/// Form terminal used during startup creation or information adjustment.
class StartupProfileSetupScreen extends ConsumerStatefulWidget {
  final bool isEditing;

  const StartupProfileSetupScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<StartupProfileSetupScreen> createState() => _StartupProfileSetupScreenState();
}

class _StartupProfileSetupScreenState extends ConsumerState<StartupProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Blank for a new registration so a founder fills in their own venture's
  // details. In edit mode, _loadExistingProfile() below populates these
  // from Firestore once, right after the screen mounts.
  final _bioController = TextEditingController();
  final _aboutController = TextEditingController();
  final _sizeController = TextEditingController();

  String? _selectedIndustry;
  bool _isSubmitting = false;

  // Reactive tracks tag matrices selection map fields
  final List<String> _availableDomains = ['Engineering', 'Design', 'Marketing', 'Business', 'Research', 'Operations', 'Content', 'Community'];
  final List<String> _selectedDomains = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadExistingProfile();
    }
  }

  Future<void> _loadExistingProfile() async {
    // .future on a StreamProvider resolves with that stream's first value —
    // exactly what's needed here, a one-time snapshot to seed the form
    // rather than a live subscription (the form fields are locally owned
    // from this point on, not bound to the stream).
    final profile = await ref.read(currentUserProfileProvider.future);
    if (!mounted || profile == null) return;
    setState(() {
      _bioController.text = profile.tagline;
      _aboutController.text = profile.about;
      _sizeController.text = profile.companySize;
      _selectedIndustry = profile.industry.isEmpty ? null : profile.industry;
      _selectedDomains
        ..clear()
        ..addAll(profile.domains);
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _aboutController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _selectedIndustry != null &&
           _bioController.text.trim().isNotEmpty &&
           _aboutController.text.trim().isNotEmpty &&
           _selectedDomains.isNotEmpty;
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    try {
      final uid = ref.read(authStateProvider).value?.uid;
      if (uid == null) throw StateError('No signed-in user.');

      await ref.read(authRepositoryProvider).updateStartupProfile(
            uid: uid,
            tagline: _bioController.text.trim(),
            about: _aboutController.text.trim(),
            companySize: _sizeController.text.trim(),
            industry: _selectedIndustry!,
            domains: _selectedDomains,
          );

      if (!mounted) return;
      if (widget.isEditing) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const StartupDashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
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
                      hint: Text('Select a sector', style: GoogleFonts.inter(fontSize: 15, color: Colors.grey.shade400)),
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
                    onPressed: (_isFormValid() && !_isSubmitting) ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aluDeepGreen,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
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
