import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaptureBankingScreen extends StatefulWidget {
  const CaptureBankingScreen({super.key});

  @override
  State<CaptureBankingScreen> createState() => _CaptureBankingScreenState();
}

class _CaptureBankingScreenState extends State<CaptureBankingScreen> {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  final List<String> _banks = [
    'Absa Bank', 'African Bank', 'Bidvest Bank', 'Capitec Bank',
    'Discovery Bank', 'FNB (First National Bank)', 'Grindrod Bank',
    'Investec Bank', 'Nedbank', 'Old Mutual', 'RMB (Rand Merchant Bank)',
    'Standard Bank', 'TymeBank', 'Ubank',
  ];

  String? _selectedBank;
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: _DiagonalClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.38,
              color: const Color(0xFFEF5350),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _GudeLogo(),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Capture Banking\nDetails', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A), height: 1.2)),
                          const SizedBox(height: 6),
                          const Text('To enable buying, payments and able to do EFT or to add a card.', style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E), height: 1.5)),
                          const SizedBox(height: 28),
                          _DropdownField(hint: 'Select your bank', value: _selectedBank, items: _banks, onChanged: (v) => setState(() => _selectedBank = v)),
                          const SizedBox(height: 16),
                          _InputField(controller: _cardNumberController, hint: 'Enter card number', keyboardType: TextInputType.number, suffixIcon: const Icon(Icons.credit_card_outlined, color: Color(0xFF9E9E9E), size: 20)),
                          const SizedBox(height: 16),
                          _InputField(controller: _cardHolderController, hint: 'Enter card holder name'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _InputField(controller: _expiryController, hint: 'MM/YY', keyboardType: TextInputType.datetime)),
                              const SizedBox(width: 16),
                              Expanded(child: _InputField(controller: _cvvController, hint: 'Enter cvv/cvc', keyboardType: TextInputType.number, obscureText: true)),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF5350),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go('/home'),
                              child: const Text('Do it Later', style: TextStyle(color: Color(0xFF757575), fontSize: 14)),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({required this.hint, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF9E9E9E)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5)),
      ),
      items: items.map((bank) => DropdownMenuItem(value: bank, child: Text(bank, style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A))))).toList(),
      onChanged: onChanged,
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({required this.controller, required this.hint, this.keyboardType = TextInputType.text, this.obscureText = false, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5)),
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _GudeLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Text('G', style: TextStyle(color: Color(0xFFEF5350), fontSize: 24, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(height: 4),
        const Text('GUDE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2)),
      ],
    );
  }
}