import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive form terminal for verified startups to publish new roles.
class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Input Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController();
  final _stipendController = TextEditingController();
  final _spotsController = TextEditingController(text: '1');

  // Reactive Selection States matching your precise chip design arrays
  String _selectedType = 'Internship';
  String _selectedDomain = 'Engineering';
  String _selectedWorkMode = 'On-site';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _stipendController.dispose();
    _spotsController.dispose();
    super.dispose();
  }

  /// Checks validation to dynamically update primary action button colors
  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
        _descController.text.trim().isNotEmpty &&
        _durationController.text.trim().isNotEmpty;
  }

  void _handleOpportunityPublish() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opportunity published successfully to ALU ecosystem!'),
          backgroundColor: Color(0xFF0C4E33),
        ),
      );
      Navigator.of(context).pop(); // Returns straight back to Startup Dashboard workspace
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);
    const Color aluLightBg = Color(0xFFF8F9FA);

    final List<String> types = ['Internship', 'Part-time', 'Project'];
    final List<String> domains = ['Engineering', 'Design', 'Marketing', 'Business', 'Research', 'Operations', 'Content', 'Community'];
    final List<String> workModes = ['On-site', 'Remote'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}), // Triggers rebuilds to evaluate button color changes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Typography Elements
                Text(
                  'Post an opportunity',
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 32, fontWeight: FontWeight.extrabold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Posting as Zuri Health',
                  style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 28),

                // Section 1: Role Title Form Box
                _buildFormSectionLabel('ROLE TITLE'),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _buildInputDecoration('e.g. Frontend Engineer Intern'),
                ),
                const SizedBox(height: 24),

                // Section 2: Opportunity Type Chips Group
                _buildFormSectionLabel('TYPE'),
                Wrap(
                  spacing: 8.0,
                  children: types.map((t) => _buildSelectionChip(t, _selectedType == t, aluDeepGreen, aluLightBg, () {
                    setState(() => _selectedType = t);
                  })).toList(),
                ),
                const SizedBox(height: 24),

                // Section 3: Domain Category Chips Group
                _buildFormSectionLabel('DOMAIN'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: domains.map((d) => _buildSelectionChip(d, _selectedDomain == d, aluDeepGreen, aluLightBg, () {
                    setState(() => _selectedDomain = d);
                  })).toList(),
                ),
                const SizedBox(height: 24),

                // Section 4: Multi-line Role Description Area
                _buildFormSectionLabel('DESCRIPTION'),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _buildInputDecoration('Describe the role, what the intern will work on, and who would thrive in this position...'),
                ),
                const SizedBox(height: 24),

                // Split Fields: Duration and Monthly Stipend
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormSectionLabel('DURATION'),
                          TextFormField(
                            controller: _durationController,
                            decoration: _buildInputDecoration('e.g. 3 months'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormSectionLabel('MONTHLY STIPEND\n(OPTIONAL)'),
                          TextFormField(
                            controller: _stipendController,
                            decoration: _buildInputDecoration('e.g. RWF 80,000'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Split Fields: Spots Available and Work Mode
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormSectionLabel('SPOTS AVAILABLE'),
                          TextFormField(
                            controller: _spotsController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration('1'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormSectionLabel('WORK MODE'),
                          const SizedBox(height: 4),
                          Row(
                            children: workModes.map((m) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: _buildSelectionChip(m, _selectedWorkMode == m, aluDeepGreen, aluLightBg, () {
                                  setState(() => _selectedWorkMode = m);
                                }),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Form Submission Controller Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _handleOpportunityPublish : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: aluDeepGreen,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Post Opportunity',
                      style: GoogleFonts.inter(
                        color: _isFormValid() ? Colors.white : Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        labelText,
style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),),);}/// Generates specialized form chip toggle components reactively matching brand highlightsWidget buildSelectionChip(String label, bool isSelected, Color activeColor, Color idleColor, VoidCallback onTap) {return ChoiceChip(label: Container(width: double.infinity,alignment: Alignment.center,
child: Text(label),),selected: isSelected,onSelected: () => onTap(),selectedColor: activeColor,backgroundColor: idleColor,labelStyle: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.grey.shade700,fontSize: 13,fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: isSelected ? activeColor : Colors.grey.shade200),
),showCheckmark: false,);}InputDecoration _buildInputDecoration(String hintText) {return InputDecoration(hintText: hintText,hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14, height: 1.3),filled: true,fillColor: Colors.white,contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
),focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: const BorderSide(color: Color(0xFF0C4E33), width: 2),),);}}
