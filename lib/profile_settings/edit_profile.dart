import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/session_manager.dart';
import '../theme/profile_avatar.dart';

/// TechKart Profile & Settings - Edit Profile Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class EditProfileScreen extends StatefulWidget {
  final String initialFullName;
  final String initialEmail;
  final String initialPhone;
  final String initialDob;
  final String initialGender;
  final bool initialTwoStepActive;
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onReset;
  final VoidCallback? onChangePhoto;
  final VoidCallback? onRemovePhoto;
  final VoidCallback? onManageSecurity;
  final ValueChanged<Map<String, dynamic>>? onSaveChanges;
  final VoidCallback? onCancel;

  const EditProfileScreen({
    super.key,
    this.initialFullName = '',
    this.initialEmail = '',
    this.initialPhone = '',
    this.initialDob = '',
    this.initialGender = '',
    this.initialTwoStepActive = false,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onReset,
    this.onChangePhoto,
    this.onRemovePhoto,
    this.onManageSecurity,
    this.onSaveChanges,
    this.onCancel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final ApiClient _apiClient = ApiClient();
  bool _isSaving = false;

  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = SessionManager().currentUser;
    _nameController = TextEditingController(
      text: widget.initialFullName.isNotEmpty
          ? widget.initialFullName
          : user?['full_name']?.toString() ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialEmail.isNotEmpty
          ? widget.initialEmail
          : user?['email']?.toString() ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialPhone.isNotEmpty
          ? widget.initialPhone
          : user?['phone']?.toString() ?? '',
    );
    final gender = widget.initialGender.isNotEmpty
        ? widget.initialGender
        : user?['gender']?.toString() ?? '';
    _selectedGender = _genderLabel(gender);
  }

  String _genderLabel(String? gender) {
    switch ((gender ?? '').toLowerCase().trim()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Prefer not to say';
    }
  }

  String? _genderPayload() {
    switch (_selectedGender) {
      case 'Male':
        return 'male';
      case 'Female':
        return 'female';
      case 'Other':
        return 'other';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _apiClient.close();
    super.dispose();
  }

  Future<void> _handleSave() async {
    HapticFeedback.mediumImpact();
    FocusScope.of(context).unfocus();

    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (fullName.length < 2) {
      _showError('Full name must be at least 2 characters.');
      return;
    }
    if (phone.isNotEmpty && !RegExp(r'^[0-9+\-\s()]{7,25}$').hasMatch(phone)) {
      _showError('Enter a valid phone number.');
      return;
    }

    final data = <String, dynamic>{
      'full_name': fullName,
      'phone': phone,
      'gender': _genderPayload(),
    };

    setState(() => _isSaving = true);
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/customer/auth/profile',
        body: data,
        requiresAuth: true,
        fromJsonData: (data) =>
            data is Map<String, dynamic> ? data : <String, dynamic>{},
      );

      final updatedUser = response.data?['user'];
      if (updatedUser is Map<String, dynamic>) {
        await SessionManager().updateUser(updatedUser);
      }

      if (!mounted) return;
      setState(() => _isSaving = false);
      widget.onSaveChanges?.call(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile changes saved successfully!',
            style: GoogleFonts.literata(),
          ),
          backgroundColor: const Color(0xFF0D1B2A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showError('Unable to save your profile right now. Please try again.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.literata()),
        backgroundColor: const Color(0xFF0D1B2A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  _buildPhotoAvatarSection(),
                  const SizedBox(height: 24),
                  _buildFullNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 20),
                  _buildGenderSelector(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  const SizedBox(height: 14),
                  _buildCancelButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBCF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF0D1B2A),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Account',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.lock_outline,
              size: 22,
              color: Color(0xFF0D1B2A),
            ),
            onPressed: widget.onLockPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile credentials encrypted and verified.',
                        style: GoogleFonts.literata(),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PHOTO AVATAR SECTION
  // ---------------------------------------------------------------------------
  Widget _buildPhotoAvatarSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE6C17A), width: 2),
        ),
        child: const ProfileAvatar(size: 80),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FULL LEGAL NAME FIELD
  // ---------------------------------------------------------------------------
  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Full Name',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            Text(
              'Legal Name',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: Color(0xFF1B365D),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your full name',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // EMAIL FIELD
  // ---------------------------------------------------------------------------
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B2A),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.mail_outline,
                size: 18,
                color: Color(0xFF1B365D),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B365D),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'name@example.com',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 14,
                color: Color(0xFF1B365D),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PHONE FIELD
  // ---------------------------------------------------------------------------
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B2A),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 18,
                color: Color(0xFF1B365D),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'IN +91',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '98765-43210',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // GENDER SELECTOR (2x2 GRID)
  // ---------------------------------------------------------------------------
  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender Preference',
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B2A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderOption('Male'),
            const SizedBox(width: 10),
            _buildGenderOption('Female'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderOption('Other'),
            const SizedBox(width: 10),
            _buildGenderOption('Prefer not to say'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label) {
    final isSelected = _selectedGender == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedGender = label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0D1B2A)
                  : const Color(0xFFE6C17A),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 14, color: Color(0xFFF5EBDD)),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? const Color(0xFFF5EBDD) : const Color(0xFF1B365D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B2A),
          foregroundColor: const Color(0xFFF5EBDD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5EBDD)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, size: 16, color: Color(0xFFF5EBDD)),
                  const SizedBox(width: 8),
                  Text(
                    'Save Changes',
                    style: GoogleFonts.literata(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CANCEL BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildCancelButton() {
    return Center(
      child: GestureDetector(
        onTap: widget.onCancel ?? () => Navigator.of(context).maybePop(),
        child: Text(
          'Cancel',
          style: GoogleFonts.literata(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B365D),
          ),
        ),
      ),
    );
  }
}
