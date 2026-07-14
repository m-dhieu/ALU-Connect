import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/opportunity.dart';
import '../providers/auth_providers.dart';
import '../providers/opportunity_providers.dart';

// form for startups to publish/edit opportunities
class PostOpportunityScreen extends ConsumerStatefulWidget {
  final Opportunity? existingOpportunity;

  const PostOpportunityScreen({super.key, this.existingOpportunity});

  bool get isEditing => existingOpportunity != null;

  @override
  ConsumerState<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends ConsumerState<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  // text input controllers
  late final _titleController = TextEditingController(text: widget.existingOpportunity?.roleTitle);
  late final _descController = TextEditingController(text: widget.existingOpportunity?.description);
  late final _durationController = TextEditingController(text: widget.existingOpportunity?.duration);
  late final _stipendController = TextEditingController(text: widget.existingOpportunity?.stipend);
  late final _spotsController = TextEditingController(text: widget.existingOpportunity?.spotsAvailable.toString() ?? '1');
  final _tagEntryController = TextEditingController();
  final _responsibilityEntryController = TextEditingController();

  // manage selected chip states
  late String _selectedType = widget.existingOpportunity?.jobType ?? 'Internship';
  late String _selectedDomain = widget.existingOpportunity?.department ?? 'Engineering';
  late String _selectedWorkMode = widget.existingOpportunity?.workplaceSetting ?? 'On-site';
  late final List<String> _skillsTags = List.of(widget.existingOpportunity?.skillsTags ?? const []);
  late final List<String> _responsibilities = List.of(widget.existingOpportunity?.responsibilities ?? const []);
  bool _isSubmitting = false;

  void _addSkillTag(String rawValue) {
    final String tag = rawValue.trim();
    _tagEntryController.clear();
    if (tag.isEmpty || _skillsTags.contains(tag)) return;
    setState(() => _skillsTags.add(tag));
  }

  void _addResponsibility(String rawValue) {
    final String item = rawValue.trim();
    _responsibilityEntryController.clear();
    if (item.isEmpty || _responsibilities.contains(item)) return;
    setState(() => _responsibilities.add(item));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _stipendController.dispose();
    _spotsController.dispose();
    _tagEntryController.dispose();
    _responsibilityEntryController.dispose();
    super.dispose();
  }

  // update action button based on form validation
  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
        _descController.text.trim().isNotEmpty &&
        _durationController.text.trim().isNotEmpty;
  }

  Future<void> _handleOpportunityPublish() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final existing = widget.existingOpportunity;
      final List<String> skillsTags = List.of(_skillsTags);
      final List<String> responsibilities = List.of(_responsibilities);

      if (existing != null) {
        final updated = existing.copyWith(
          roleTitle: _titleController.text.trim(),
          description: _descController.text.trim(),
          workplaceSetting: _selectedWorkMode,
          duration: _durationController.text.trim(),
          jobType: _selectedType,
          department: _selectedDomain,
          stipend: _stipendController.text.trim(),
          spotsAvailable: int.tryParse(_spotsController.text.trim()) ?? 1,
          skillsTags: skillsTags,
          responsibilities: responsibilities,
        );
        await ref.read(opportunitiesRepositoryProvider).updateOpportunity(updated);
      } else {
        final uid = ref.read(authRepositoryProvider).currentUser?.uid;
        final profile = ref.read(currentUserProfileProvider).value;
        if (uid == null) {
          throw StateError('No signed-in user — cannot attribute this posting to a founder.');
        }

        // use same founder avatar initials across screens
        final String founderName = profile?.fullName ?? 'Startup';
        final String initials = founderName
            .trim()
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty)
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();

        final opportunity = Opportunity(
          id: '', // ignored (Firestore assigns real id)
          postedByUid: uid,
          companyName: founderName,
          logoInit: initials.isEmpty ? '?' : initials,
          logoColor: const Color(0xFF0C4E33),
          roleTitle: _titleController.text.trim(),
          description: _descController.text.trim(),
          workplaceSetting: _selectedWorkMode,
          duration: _durationController.text.trim(),
          jobType: _selectedType,
          department: _selectedDomain,
          stipend: _stipendController.text.trim(),
          spotsAvailable: int.tryParse(_spotsController.text.trim()) ?? 1,
          skillsTags: skillsTags,
          responsibilities: responsibilities,
          createdAt: DateTime.now(), 
        );

        await ref.read(opportunitiesRepositoryProvider).postOpportunity(opportunity);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(existing != null
              ? 'Opportunity updated successfully!'
              : 'Opportunity published successfully to ALU ecosystem!'),
          backgroundColor: const Color(0xFF0C4E33),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save this opportunity: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
            onChanged: () => setState(() {}), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? 'Edit opportunity' : 'Post an opportunity',
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isEditing ? 'Update the details for this listing' : 'Posting as Zuri Health',
                  style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 28),

                // section1: role title form box
                _buildFormSectionLabel('ROLE TITLE'),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _buildInputDecoration('e.g. Frontend Engineer Intern'),
                ),
                const SizedBox(height: 24),

                // section2: opportunity type chips group
                _buildFormSectionLabel('TYPE'),
                Wrap(
                  spacing: 8.0,
                  children: types.map((t) => _buildSelectionChip(t, _selectedType == t, aluDeepGreen, aluLightBg, () {
                    setState(() => _selectedType = t);
                  })).toList(),
                ),
                const SizedBox(height: 24),

                // section3: domain category chips group
                _buildFormSectionLabel('DOMAIN'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: domains.map((d) => _buildSelectionChip(d, _selectedDomain == d, aluDeepGreen, aluLightBg, () {
                    setState(() => _selectedDomain = d);
                  })).toList(),
                ),
                const SizedBox(height: 24),

                // section4: multi-line role description area
                _buildFormSectionLabel('DESCRIPTION'),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _buildInputDecoration('Describe the role, what the intern will work on, and who would thrive in this position...'),
                ),
                const SizedBox(height: 24),

                // duration & stipend fields
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

                // spots available & work mode
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
                const SizedBox(height: 24),

                // show founder added responsibilities list
                _buildFormSectionLabel("WHAT YOU'LL DO"),
                TextFormField(
                  controller: _responsibilityEntryController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _buildInputDecoration('e.g. Design onboarding screens — press enter to add').copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle, color: aluDeepGreen),
                      onPressed: () => _addResponsibility(_responsibilityEntryController.text),
                    ),
                  ),
                  onFieldSubmitted: _addResponsibility,
                ),
                if (_responsibilities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ..._responsibilities.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('→  ', style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(item, style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        InkWell(
                          onTap: () => setState(() => _responsibilities.remove(item)),
                          child: Icon(Icons.close, size: 16, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )),
                ],
                const SizedBox(height: 24),

                // show founder added skills & tags as chips
                _buildFormSectionLabel('REQUIRED SKILLS & TAGS'),
                TextFormField(
                  controller: _tagEntryController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _buildInputDecoration('e.g. Figma — press enter to add').copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle, color: aluDeepGreen),
                      onPressed: () => _addSkillTag(_tagEntryController.text),
                    ),
                  ),
                  onFieldSubmitted: _addSkillTag,
                ),
                if (_skillsTags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _skillsTags.map((tag) => Chip(
                      label: Text(tag),
                      labelStyle: GoogleFonts.inter(color: Colors.grey.shade800, fontSize: 13, fontWeight: FontWeight.w600),
                      backgroundColor: aluLightBg,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _skillsTags.remove(tag)),
                      side: BorderSide(color: Colors.grey.shade200),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 36),

                // handle form submission action
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isFormValid() && !_isSubmitting) ? _handleOpportunityPublish : null,
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
                            widget.isEditing ? 'Save Changes' : 'Post Opportunity',
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
        style: GoogleFonts.inter(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  // reactive form chip toggle components
  Widget _buildSelectionChip(String label, bool isSelected, Color activeColor, Color idleColor, VoidCallback onTap) {
    return ChoiceChip(
      label: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(label),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: activeColor,
      backgroundColor: idleColor,
      labelStyle: GoogleFonts.inter(
        color: isSelected ? Colors.white : Colors.grey.shade700,
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isSelected ? activeColor : Colors.grey.shade200),
      ),
      showCheckmark: false,
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14, height: 1.3),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0C4E33), width: 2),
      ),
    );
  }
}
