import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gude_button.dart';

const List<String> kSouthAfricanUniversities = [
  'University of the Witwatersrand (Wits)',
  'University of Cape Town (UCT)',
  'University of Pretoria (UP)',
  'University of Johannesburg (UJ)',
  'Stellenbosch University',
  'University of KwaZulu-Natal (UKZN)',
  'University of the Free State (UFS)',
  'Rhodes University',
  'North-West University (NWU)',
  'University of Limpopo',
  'University of Venda',
  'Walter Sisulu University',
  'Central University of Technology (CUT)',
  'Durban University of Technology (DUT)',
  'Cape Peninsula University of Technology (CPUT)',
  'Tshwane University of Technology (TUT)',
  'Vaal University of Technology (VUT)',
  'Mangosuthu University of Technology (MUT)',
  'Nelson Mandela University (NMU)',
  'Sol Plaatje University',
  'University of Mpumalanga',
  'Sefako Makgatho Health Sciences University',
  'Other TVET / College',
];

const List<String> kYearsOfStudy = [
  '1st Year',
  '2nd Year',
  '3rd Year',
  '4th Year',
  'Honours',
  'Masters',
  'PhD',
  'TVET N1–N3',
  'TVET N4–N6',
];

class StudentVerifyScreen extends ConsumerStatefulWidget {
  const StudentVerifyScreen({super.key});

  @override
  ConsumerState<StudentVerifyScreen> createState() => _StudentVerifyScreenState();
}

class _StudentVerifyScreenState extends ConsumerState<StudentVerifyScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _studentNumCtrl  = TextEditingController();
  String? _selectedUniversity;
  String? _selectedYear;
  bool _isLoading        = false;
  // In production: use image_picker to upload student card
  bool _cardUploaded     = false;

  @override
  void dispose() {
    _studentNumCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUniversity == null) {
      _showError('Please select your university');
      return;
    }
    if (_selectedYear == null) {
      _showError('Please select your year of study');
      return;
    }

    setState(() => _isLoading = true);
    // TODO: Save to Firestore + trigger student verification
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) context.go(AppRoutes.captureBanking);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────
            Container(
              width: double.infinity,
              height: size.height * 0.22,
              decoration: const BoxDecoration(
                color: AppColors.gudeRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        AppStrings.verifyStudent,
                        style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700,
                          color: AppColors.white, fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Confirm you\'re a South African student 🎓',
                        style: TextStyle(
                          fontSize: 13, color: Colors.white70, fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),

                    // Step indicator
                    _StepIndicator(currentStep: 1, totalSteps: 3),
                    const SizedBox(height: 28),

                    // University dropdown
                    _DropdownField(
                      label: AppStrings.selectUniversity,
                      hint: 'Choose your university',
                      value: _selectedUniversity,
                      items: kSouthAfricanUniversities,
                      onChanged: (v) => setState(() => _selectedUniversity = v),
                      prefixIcon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Student Number
                    AuthTextField(
                      label: AppStrings.studentNumber,
                      hint: 'e.g. 2019012345',
                      controller: _studentNumCtrl,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textHint, size: 20),
                      validator: Validators.studentNumber,
                    ),
                    const SizedBox(height: 16),

                    // Year of Study
                    _DropdownField(
                      label: AppStrings.yearOfStudy,
                      hint: 'Select year',
                      value: _selectedYear,
                      items: kYearsOfStudy,
                      onChanged: (v) => setState(() => _selectedYear = v),
                      prefixIcon: Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 24),

                    // Upload Student Card
                    const Text(
                      AppStrings.uploadStudentId,
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary, fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // TODO: image_picker
                        setState(() => _cardUploaded = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student card upload — add image_picker')),
                        );
                      },
                      child: Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _cardUploaded
                              ? AppColors.success.withOpacity(0.08)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _cardUploaded ? AppColors.success : AppColors.border,
                            width: _cardUploaded ? 1.5 : 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _cardUploaded
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.cloud_upload_outlined,
                              size: 32,
                              color: _cardUploaded ? AppColors.success : AppColors.textHint,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _cardUploaded
                                  ? 'Student card uploaded ✓'
                                  : 'Tap to upload your student card',
                              style: TextStyle(
                                fontSize: 13,
                                color: _cardUploaded ? AppColors.success : AppColors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (!_cardUploaded)
                              const Text(
                                'JPG, PNG — max 5MB',
                                style: TextStyle(
                                  fontSize: 11, color: AppColors.textHint, fontFamily: 'Poppins',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Info chip
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your student data is encrypted and only used to verify your eligibility.',
                              style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary,
                                height: 1.4, fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    GudeButton(
                      label: AppStrings.continueBtn,
                      onPressed: _submit,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),
                    GudeButton(
                      label: 'Skip for now',
                      isOutlined: true,
                      onPressed: () => context.go(AppRoutes.captureBanking),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable dropdown field ─────────────────────────────
class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData prefixIcon;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: AppColors.textHint, fontSize: 14, fontFamily: 'Poppins')),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: AppColors.textHint, size: 20),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'))))
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
    );
  }
}

// ── Step indicator ──────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i < currentStep;
        final current = i == currentStep - 1;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            height: 5,
            decoration: BoxDecoration(
              color: active || current ? AppColors.gudeRed : AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
