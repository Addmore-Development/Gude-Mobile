import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Brand colors (consistent with wallet_screen.dart)
const _red = Color(0xFFE30613);
const _redDark = Color(0xFFC0000F);
const _success = Color(0xFF4CAF50);
const _warning = Color(0xFFFFC107);
const _surface = Color(0xFFF2F2F2);
const _offWhite = Color(0xFFF8F8F8);
const _border = Color(0xFFE0E0E0);
const _txt1 = Color(0xFF1A1A1A);
const _txt2 = Color(0xFF666666);
const _txtHint = Color(0xFF9E9E9E);

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  int _step = 0; // 0=select recipient, 1=pay details, 2=success
  int _selectedContact = -1;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  bool _immediate = false;

  final List<Map<String, String>> _contacts = [
    {'name': 'Susan Precious', 'number': '+2769335215', 'initials': 'SP', 'color': '0xFFE91E63'},
    {'name': 'Kinalwe Hope',   'number': '+2761234567', 'initials': 'KH', 'color': '0xFF4CAF50'},
    {'name': 'Pearl Hlogwane',  'number': '+2769876543', 'initials': 'PH', 'color': '0xFF9C27B0'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _offWhite,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
            setState(() => _step--);
          }
        },
      ),
      title: Column(
        children: [
          const Text(
            'Send Money',
            style: TextStyle(fontSize: 12, color: _txtHint),
          ),
          Text(
            _step == 0 ? 'Select Recipient' : (_step == 1 ? 'Payment Details' : 'Transaction Details'),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _txt1),
          ),
        ],
      ),
      actions: [
        if (_step != 2)
          TextButton(
            onPressed: _step == 1 ? _validateAndProceed : null,
            child: const Text(
              'Next',
              style: TextStyle(color: _red, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case 0:
        return _selectRecipient();
      case 1:
        return _payDetails();
      case 2:
        return _success();
      default:
        return const SizedBox();
    }
  }

  Widget _selectRecipient() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who do you want to send money to?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _txt1),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTab('Contact', true),
                  const SizedBox(width: 8),
                  _buildTab('Group', false),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Contact Names', style: TextStyle(color: _txtHint, fontSize: 13)),
                  Icon(Icons.sort, color: _txtHint, size: 18),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _contacts.length,
            itemBuilder: (_, i) {
              final c = _contacts[i];
              return _ContactTile(
                name: c['name']!,
                number: c['number']!,
                initials: c['initials']!,
                colorHex: c['color']!,
                isSelected: _selectedContact == i,
                onTap: () => setState(() => _selectedContact = i),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () => context.go('/wallet'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _red),
                  minimumSize: const Size(100, 48),
                ),
                child: const Text('Cancel', style: TextStyle(color: _red)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectedContact >= 0
                      ? () => setState(() => _step = 1)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Continue', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? _red : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? _red : _border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : _txt2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _payDetails() {
    if (_selectedContact < 0) return const SizedBox();
    final c = _contacts[_selectedContact];
    final amountText = _amountController.text;
    final displayAmount = amountText.isEmpty ? '0.00' : amountText;
    final formattedAmount = NumberFormat.currency(locale: 'en_ZA', symbol: 'R ').format(double.tryParse(displayAmount) ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(int.parse(c['color']!)),
                  child: Text(
                    c['initials']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  c['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _txt1),
                ),
                const SizedBox(height: 4),
                Text(
                  c['number']!,
                  style: const TextStyle(color: _txtHint, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoRow('From Account', 'Current Balance', 'R 190.00 ZAR'),
          const SizedBox(height: 16),
          _buildInfoRow('To', c['name']!, c['number']!),
          const SizedBox(height: 16),
          const Text('Amount', style: TextStyle(fontSize: 13, color: _txtHint)),
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
          const SizedBox(height: 16),
          const Text('Transfer Speed', style: TextStyle(fontSize: 13, color: _txtHint)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _immediate = false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: !_immediate ? _red : _border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Normal EFT',
                    style: TextStyle(color: !_immediate ? _red : _txt2),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _immediate = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _immediate ? _red : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Immediate EFT',
                    style: TextStyle(color: _immediate ? Colors.white : _txt2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('My reference', style: TextStyle(fontSize: 13, color: _txtHint)),
          const SizedBox(height: 6),
          TextField(
            controller: _refController,
            decoration: InputDecoration(
              hintText: 'Reference (optional)',
              hintStyle: const TextStyle(color: _txtHint),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _red),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an amount')),
                );
                return;
              }
              setState(() => _step = 2);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Send Money', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _success() {
    if (_selectedContact < 0) return const SizedBox();
    final c = _contacts[_selectedContact];
    final amountText = _amountController.text;
    final amount = double.tryParse(amountText) ?? 0.0;
    final formattedAmount = NumberFormat.currency(locale: 'en_ZA', symbol: 'R ').format(amount);
    final now = DateTime.now();
    final formattedDateTime = DateFormat('dd MMM yyyy, HH:mm').format(now);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              formattedAmount,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _txt1),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSuccessDetailRow('From Account', 'Current Balance', 'R 190.00 ZAR'),
                  const Divider(height: 24, color: _border),
                  _buildSuccessDetailRow('To', c['name']!, ''),
                  _buildSuccessDetailRow('Date & Time', formattedDateTime, ''),
                  _buildSuccessDetailRow('Status', 'Successful', ''),
                  if (_refController.text.isNotEmpty)
                    _buildSuccessDetailRow('Reference', _refController.text, ''),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _step = 0;
                  _selectedContact = -1;
                  _amountController.clear();
                  _refController.clear();
                  _immediate = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _red,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Send Money Again', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/wallet'),
              child: const Text('Back to Wallet', style: TextStyle(color: _red, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String? sub) {
    return Row(
      children: [
        const Icon(Icons.account_balance, size: 18, color: _txtHint),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: _txtHint)),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _txt1)),
              if (sub != null && sub.isNotEmpty)
                Text(sub, style: const TextStyle(fontSize: 11, color: _txtHint)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessDetailRow(String label, String value, String? sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12, color: _txtHint)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _txt1)),
                if (sub != null && sub.isNotEmpty)
                  Text(sub, style: const TextStyle(fontSize: 11, color: _txtHint)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndProceed() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }
    setState(() => _step = 2);
  }
}

class _ContactTile extends StatelessWidget {
  final String name;
  final String number;
  final String initials;
  final String colorHex;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactTile({
    required this.name,
    required this.number,
    required this.initials,
    required this.colorHex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? _red : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(int.parse(colorHex)),
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, color: _txt1),
        ),
        subtitle: Text(
          'Created by | 1 May 2025', // placeholder; could be dynamic
          style: const TextStyle(fontSize: 11, color: _txtHint),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: _red, size: 20)
            : null,
        onTap: onTap,
      ),
    );
  }
}