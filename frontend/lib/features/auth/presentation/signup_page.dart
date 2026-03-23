import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/shared/widgets/gude_header.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _customInstitution = TextEditingController();
  final _city = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _selectedInstitution;
  bool _showCustomInput = false;

  // All South African universities + TVET colleges
  static const List<Map<String, dynamic>> _institutions = [
    // Traditional Universities
    {'name': 'University of Cape Town (UCT)', 'domain': 'uct.ac.za', 'type': 'university'},
    {'name': 'University of the Witwatersrand (Wits)', 'domain': 'wits.ac.za', 'type': 'university'},
    {'name': 'Stellenbosch University (SU)', 'domain': 'sun.ac.za', 'type': 'university'},
    {'name': 'University of KwaZulu-Natal (UKZN)', 'domain': 'ukzn.ac.za', 'type': 'university'},
    {'name': 'University of Pretoria (UP)', 'domain': 'up.ac.za', 'type': 'university'},
    {'name': 'University of the Free State (UFS)', 'domain': 'ufs.ac.za', 'type': 'university'},
    {'name': 'Rhodes University (RU)', 'domain': 'ru.ac.za', 'type': 'university'},
    {'name': 'North-West University (NWU)', 'domain': 'nwu.ac.za', 'type': 'university'},
    {'name': 'University of Limpopo (UL)', 'domain': 'ul.ac.za', 'type': 'university'},
    {'name': 'University of Fort Hare (UFH)', 'domain': 'ufh.ac.za', 'type': 'university'},
    {'name': 'University of Venda (UniVen)', 'domain': 'univen.ac.za', 'type': 'university'},
    {'name': 'Walter Sisulu University (WSU)', 'domain': 'wsu.ac.za', 'type': 'university'},
    // Universities of Technology
    {'name': 'Tshwane University of Technology (TUT)', 'domain': 'tut.ac.za', 'type': 'university'},
    {'name': 'University of Johannesburg (UJ)', 'domain': 'uj.ac.za', 'type': 'university'},
    {'name': 'Cape Peninsula University of Technology (CPUT)', 'domain': 'cput.ac.za', 'type': 'university'},
    {'name': 'Durban University of Technology (DUT)', 'domain': 'dut.ac.za', 'type': 'university'},
    {'name': 'Mangosuthu University of Technology (MUT)', 'domain': 'mut.ac.za', 'type': 'university'},
    {'name': 'Central University of Technology (CUT)', 'domain': 'cut.ac.za', 'type': 'university'},
    {'name': 'Vaal University of Technology (VUT)', 'domain': 'vut.ac.za', 'type': 'university'},
    // Comprehensive Universities
    {'name': 'Nelson Mandela University (NMU)', 'domain': 'mandela.ac.za', 'type': 'university'},
    {'name': 'University of the Western Cape (UWC)', 'domain': 'uwc.ac.za', 'type': 'university'},
    {'name': 'Sol Plaatje University (SPU)', 'domain': 'spu.ac.za', 'type': 'university'},
    {'name': 'University of Mpumalanga (UMP)', 'domain': 'ump.ac.za', 'type': 'university'},
    // TVET Colleges
    {'name': 'Ekurhuleni East TVET College', 'domain': 'ekurhulenieast.edu.za', 'type': 'tvet'},
    {'name': 'Coastal KZN TVET College', 'domain': 'coastalkzn.edu.za', 'type': 'tvet'},
    {'name': 'College of Cape Town TVET', 'domain': 'cct.edu.za', 'type': 'tvet'},
    {'name': 'False Bay TVET College', 'domain': 'falsebay.edu.za', 'type': 'tvet'},
    {'name': 'Boland TVET College', 'domain': 'boland.edu.za', 'type': 'tvet'},
    {'name': 'Northlink TVET College', 'domain': 'northlink.edu.za', 'type': 'tvet'},
    {'name': 'South West Gauteng TVET College', 'domain': 'swgc.edu.za', 'type': 'tvet'},
    {'name': 'Tshwane South TVET College', 'domain': 'tsc.edu.za', 'type': 'tvet'},
    {'name': 'Sedibeng TVET College', 'domain': 'sedibeng.edu.za', 'type': 'tvet'},
    {'name': 'Orbit TVET College', 'domain': 'orbit.edu.za', 'type': 'tvet'},
    {'name': 'Other (type below)', 'domain': '', 'type': 'other'},
  ];

  String? _getInstitutionDomain() {
    if (_selectedInstitution == null) return null;
    final match = _institutions.firstWhere(
      (i) => i['name'] == _selectedInstitution,
      orElse: () => {'domain': ''},
    );
    return match['domain'] as String?;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    // If a known institution is selected, validate against its domain
    final domain = _getInstitutionDomain();
    if (domain != null && domain.isNotEmpty) {
      if (!value.toLowerCase().endsWith('@$domain')) {
        return 'Use your student email ending in @$domain';
      }
      return null;
    }
    // Fallback: accept any .ac.za or .edu.za email
    final genericRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.(ac\.za|edu\.za)$',
      caseSensitive: false,
    );
    if (!genericRegex.hasMatch(value)) {
      return 'Use your official student email (.ac.za or .edu.za)';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    if (value.trim().split(' ').length < 2) return 'Enter first and last name';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final domain = _getInstitutionDomain();
    final emailHint = (domain != null && domain.isNotEmpty)
        ? 'e.g. s12345678@$domain'
        : 'e.g. s12345678@university.ac.za';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GudeHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.inputBorder))),
                      child: Row(children: [
                        _tab('Log In', false, () => context.go('/login')),
                        _tab('Sign Up', true, () {}),
                      ]),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    _label('Full Name *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _name,
                      validator: _validateName,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Enter first and last name',
                        prefixIcon: Icon(Icons.person_outline, color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Institution Dropdown
                    _label('University / TVET College *'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedInstitution,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.school_outlined, color: AppColors.textGrey, size: 20),
                        hintText: 'Select your institution',
                      ),
                      items: _institutions.map((inst) {
                        final type = inst['type'] as String;
                        return DropdownMenuItem<String>(
                          value: inst['name'] as String,
                          child: Row(
                            children: [
                              Icon(
                                type == 'tvet' ? Icons.business_outlined : type == 'other' ? Icons.edit_outlined : Icons.school_outlined,
                                size: 16,
                                color: type == 'other' ? AppColors.primary : AppColors.textGrey,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  inst['name'] as String,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: type == 'other' ? AppColors.primary : const Color(0xFF1A1A1A),
                                    fontWeight: type == 'other' ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      validator: (v) => v == null ? 'Please select your institution' : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedInstitution = value;
                          _showCustomInput = value == 'Other (type below)';
                          _email.clear();
                        });
                      },
                    ),

                    // Custom institution input
                    if (_showCustomInput) ...[
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _customInstitution,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => _showCustomInput && (v == null || v.isEmpty)
                            ? 'Please enter your institution name'
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'Type your institution name',
                          prefixIcon: Icon(Icons.edit_outlined, color: AppColors.textGrey, size: 20),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Student Email
                    _label('Student Email *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _email,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: emailHint,
                        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      domain != null && domain.isNotEmpty
                          ? 'Must end in @$domain'
                          : 'Must be your official student email (.ac.za or .edu.za)',
                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 16),

                    // City
                    _label('City *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _city,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => v == null || v.isEmpty ? 'City is required' : null,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Port Elizabeth',
                        prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _label('Create Password *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Minimum 8 characters',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textGrey, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.textGrey, size: 20),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: _signup,
                      child: const Text('Create Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/login'),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: AppColors.textGrey),
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textGrey));

  Widget _tab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          )),
        ),
        child: Text(label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textGrey,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          )),
      ),
    );
  }
}