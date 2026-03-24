import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Brand colours (consistent with wallet_screen.dart)
const _red      = Color(0xFFE30613);
const _redDark  = Color(0xFFC0000F);
const _success  = Color(0xFF4CAF50);
const _warning  = Color(0xFFFFC107);
const _surface  = Color(0xFFF2F2F2);
const _offWhite = Color(0xFFF8F8F8);
const _border   = Color(0xFFE0E0E0);
const _txt1     = Color(0xFF1A1A1A);
const _txt2     = Color(0xFF666666);
const _txtHint  = Color(0xFF9E9E9E);

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int _step = 0; // 0 = enter details, 1 = success
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String? _selectedStore;

  // Mock balance – replace with real data from your state management
  final double _balance = 190.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: _buildAppBar(),
      body: _step == 1 ? _successView() : _withdrawForm(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _txt1),
        onPressed: () {
          if (_step == 0) {
            context.go('/wallet');
          } else {
            setState(() => _step = 0);
          }
        },
      ),
      title: const Text(
        'Cash Withdraw',
        style: TextStyle(fontWeight: FontWeight.bold, color: _txt1),
      ),
      centerTitle: true,
    );
  }

  Widget _withdrawForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Get a guidecode to withdraw cash at a till point.',
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // From Account
          const Text('From Account', style: TextStyle(fontSize: 12, color: _txtHint)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, size: 18, color: _txtHint),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current balance', style: TextStyle(fontSize: 12, color: _txtHint)),
                    Text(
                      NumberFormat.currency(locale: 'en_ZA', symbol: 'R ').format(_balance),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Amount
          const Text('Amount', style: TextStyle(fontSize: 12, color: _txtHint)),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'R 0.00',
              hintStyle: const TextStyle(color: _txtHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _red),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Withdraw amount must be from R20.00 to R4500.00',
            style: TextStyle(fontSize: 11, color: _txtHint),
          ),
          const SizedBox(height: 16),

          // PIN
          const Text('Pin', style: TextStyle(fontSize: 12, color: _txtHint)),
          const SizedBox(height: 6),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              hintText: 'PIN',
              hintStyle: const TextStyle(color: _txtHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _red),
              ),
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Please create a secret pin (4 digits) for money withdrawal',
            style: TextStyle(fontSize: 11, color: _txtHint),
          ),
          const SizedBox(height: 16),

          // Retail partner dropdown
          const Text('Please choose a retail partner', style: TextStyle(fontSize: 12, color: _txtHint)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedStore,
            decoration: InputDecoration(
              hintText: 'Choose a Store',
              hintStyle: const TextStyle(color: _txtHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _red),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Boxer', child: Text('Boxer')),
              DropdownMenuItem(value: 'Checkers', child: Text('Checkers')),
              DropdownMenuItem(value: 'PnP', child: Text('Pick n Pay')),
              DropdownMenuItem(value: 'Spar', child: Text('Spar')),
            ],
            onChanged: (value) => setState(() => _selectedStore = value),
          ),
          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateAndSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Get Guidecode', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _successView() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final formattedAmount = NumberFormat.currency(locale: 'en_ZA', symbol: 'R ').format(amount);
    final guidecode = _generateGuidecode();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: _success, size: 80),
            const SizedBox(height: 16),
            Text(
              formattedAmount,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _txt1),
            ),
            const Text(
              'Withdrawal Successfully',
              style: TextStyle(color: _success, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    guidecode,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For security reasons, this voucher will only be valid for 3 hours.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: _txtHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: implement download voucher
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download voucher feature coming soon')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Download Voucher', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/wallet'),
              child: const Text('Go back to wallet', style: TextStyle(color: _red)),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showError('Please enter an amount');
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null) {
      _showError('Invalid amount');
      return;
    }
    if (amount < 20) {
      _showError('Minimum withdrawal amount is R20.00');
      return;
    }
    if (amount > 4500) {
      _showError('Maximum withdrawal amount is R4500.00');
      return;
    }
    if (amount > _balance) {
      _showError('Insufficient balance');
      return;
    }

    final pin = _pinController.text.trim();
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      _showError('PIN must be 4 digits');
      return;
    }

    if (_selectedStore == null) {
      _showError('Please select a retail partner');
      return;
    }

    // All validations passed
    setState(() => _step = 1);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: _red),
    );
  }

  String _generateGuidecode() {
    // Generate a realistic guidecode (mock)
    final random = DateTime.now().millisecondsSinceEpoch % 1000000;
    final parts = [
      'FFNP',
      '${(random ~/ 1000) % 10000}'.padLeft(4, '0'),
      '${random % 10000}'.padLeft(4, '0'),
      '${(random * 13) % 100}'.padLeft(2, '0'),
    ];
    return parts.join(' ');
  }
}