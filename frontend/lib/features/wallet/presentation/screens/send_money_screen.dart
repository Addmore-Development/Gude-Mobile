import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// ─────────────────────────────────────────────────────────────────────────────
// SEND MONEY PAGE
// Step 0 → Select Recipient (Contact / Group tabs, contact list)
// Step 1 → Pay Details (from/to, amount, EFT type, reference)
// Step 2 → Transaction Details / Success
// ─────────────────────────────────────────────────────────────────────────────

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  int _step = 0;
  int _selectedContact = -1;
  int _contactTab = 0; // 0=Contact, 1=Group
  bool _immediate = false;

  final _amountController = TextEditingController();
  final _refController = TextEditingController();

  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Susan Precious',
      'number': '+2769335215',
      'initials': 'SP',
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Kinalwe Hope',
      'number': '+2761234567',
      'initials': 'KH',
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Pearl Hlogwane',
      'number': '+2769876543',
      'initials': 'PH',
      'color': const Color(0xFF9C27B0),
    },
    {
      'name': 'Pearl Hlogwane',
      'number': '+2761234578',
      'initials': 'PH',
      'color': const Color(0xFF9C27B0),
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _refController.dispose();
    super.dispose();
  }

  String get _appBarSub {
    if (_step == 0) return '1/1 Select Recipient';
    if (_step == 1) return 'Pay';
    return 'Transaction Details';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _step == 0
            ? _SelectRecipientStep(
                key: const ValueKey(0),
                contacts: _contacts,
                selected: _selectedContact,
                contactTab: _contactTab,
                onTabChange: (i) => setState(() => _contactTab = i),
                onSelect: (i) => setState(() => _selectedContact = i),
                onCancel: () => context.go('/wallet'),
                onBack: () => context.go('/wallet'),
                onContinue: _selectedContact >= 0
                    ? () => setState(() => _step = 1)
                    : null,
              )
            : _step == 1
                ? _PayDetailsStep(
                    key: const ValueKey(1),
                    contact: _contacts[_selectedContact],
                    amountController: _amountController,
                    refController: _refController,
                    immediate: _immediate,
                    onToggleEft: (v) => setState(() => _immediate = v),
                    onSend: () => setState(() => _step = 2),
                  )
                : _SuccessStep(
                    key: const ValueKey(2),
                    contact: _contacts[_selectedContact],
                    amount: _amountController.text.isEmpty
                        ? '100'
                        : _amountController.text,
                    onSendAgain: () => setState(() {
                      _step = 0;
                      _selectedContact = -1;
                      _amountController.clear();
                      _refController.clear();
                    }),
                    onBackToWallet: () => context.go('/wallet'),
                  ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,
            size: 18, color: Color(0xFF232323)),
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
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
            ),
          ),
          Text(
            _appBarSub,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF232323),
            ),
          ),
        ],
      ),
      // Red progress bar under app bar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          height: 3,
          color: const Color(0xFFFF3B3C),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 0 — SELECT RECIPIENT
// ─────────────────────────────────────────────────────────────────────────────

class _SelectRecipientStep extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final int selected;
  final int contactTab;
  final void Function(int) onTabChange;
  final void Function(int) onSelect;
  final VoidCallback onCancel;
  final VoidCallback onBack;
  final VoidCallback? onContinue;

  const _SelectRecipientStep({
    super.key,
    required this.contacts,
    required this.selected,
    required this.contactTab,
    required this.onTabChange,
    required this.onSelect,
    required this.onCancel,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Headline ──
              const Text(
                'Who do you want to send\nMoney to?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF232323),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),

              // ── Contact | Group tabs ──
              // ── Contact | Group tabs ──
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _ContactTab(
      label: 'Contact',
      selected: contactTab == 0,
      onTap: () => onTabChange(0),
    ),
    _ContactTab(
      label: 'Group',
      selected: contactTab == 1,
      onTap: () => onTabChange(1),
    ),
  ],
),
              const SizedBox(height: 20),

              // ── Column header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contact Names',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Sort By',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.sort_rounded,
                          size: 16, color: Color(0xFF999999)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Contact List ──
        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            itemCount: contacts.length,
            itemBuilder: (_, i) {
              final c = contacts[i];
              final isSelected = selected == i;
              return _ContactTile(
                contact: c,
                isSelected: isSelected,
                onTap: () => onSelect(i),
              );
            },
          ),
        ),

        // ── Bottom Buttons ──
        Container(
  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
  decoration: const BoxDecoration(
    color: Colors.white,
    border: Border(
      top: BorderSide(color: Color(0xFFF2F2F2), width: 1),
    ),
  ),
  child: Row(
    children: [
      // Cancel – text only, no button
      GestureDetector(
        onTap: onCancel,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      // Back – pill‑shaped
      Expanded(
        child: OutlinedButton(
          onPressed: onBack,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF555555),
            side: const BorderSide(color: Color(0xFFDDDDDD)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Back',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      // Continue – pill‑shaped
      Expanded(
        child: ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3B3C),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFFF3B3C).withOpacity(0.4),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
}

class _ContactTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ContactTab(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF3B3C)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? const Color(0xFFFF3B3C) : const Color(0xFF999999),
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Map<String, dynamic> contact;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactTile({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF3B3C).withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFFFF3B3C).withOpacity(0.2),
                  width: 1)
              : null,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: contact['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  contact['initials'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF232323),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Created by | 1 May 2025',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFFFF3B3C), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 1 — PAY DETAILS
// ─────────────────────────────────────────────────────────────────────────────

class _PayDetailsStep extends StatelessWidget {
  final Map<String, dynamic> contact;
  final TextEditingController amountController;
  final TextEditingController refController;
  final bool immediate;
  final void Function(bool) onToggleEft;
  final VoidCallback onSend;

  const _PayDetailsStep({
    super.key,
    required this.contact,
    required this.amountController,
    required this.refController,
    required this.immediate,
    required this.onToggleEft,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Recipient avatar ──
          Center(
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: contact['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact['initials'] as String,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  contact['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF232323),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact['number'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── From Account ──
          _DetailCard(
            icon: Icons.account_balance_outlined,
            label: 'From Account',
            title: 'Current Balance',
            sub: 'R190.00 ZAR',
          ),

          const SizedBox(height: 12),

          // ── To ──
          _DetailCard(
            icon: Icons.person_outline_rounded,
            label: 'To',
            title: contact['name'] as String,
            sub: contact['number'] as String,
          ),

          const SizedBox(height: 20),

          // ── Amount ──
          const Text(
            'Amount',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 6),
          _StyledTextField(
            controller: amountController,
            hint: 'R 0.00',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),

          const SizedBox(height: 16),

          // ── EFT Type ──
          Row(
            children: [
              Expanded(
                child: _EftButton(
                  label: 'Normal EFT',
                  selected: !immediate,
                  isOutlined: true,
                  onTap: () => onToggleEft(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _EftButton(
                  label: 'Immediate EFT',
                  selected: immediate,
                  isOutlined: false,
                  onTap: () => onToggleEft(true),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── My reference ──
          const Text(
            'My reference',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 6),
          _StyledTextField(
            controller: refController,
            hint: 'Reference',
          ),

          const SizedBox(height: 32),

          // ── Send Money button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B3C),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Send Money',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;
  final String sub;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.title,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B3C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                size: 18,
                color: const Color(0xFFFF3B3C)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF232323),
                  ),
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF999999),
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

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: Color(0xFF232323),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Color(0xFFBBBBBB),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFFFF3B3C), width: 1.5),
        ),
      ),
    );
  }
}

class _EftButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isOutlined;
  final VoidCallback onTap;

  const _EftButton({
    required this.label,
    required this.selected,
    required this.isOutlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: selected
              ? (isOutlined ? Colors.white : const Color(0xFFFF3B3C))
              : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFFFF3B3C)
                : const Color(0xFFDDDDDD),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected
                  ? (isOutlined
                      ? const Color(0xFFFF3B3C)
                      : Colors.white)
                  : const Color(0xFF999999),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2 — TRANSACTION DETAILS / SUCCESS
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessStep extends StatelessWidget {
  final Map<String, dynamic> contact;
  final String amount;
  final VoidCallback onSendAgain;
  final VoidCallback onBackToWallet;

  const _SuccessStep({
    super.key,
    required this.contact,
    required this.amount,
    required this.onSendAgain,
    required this.onBackToWallet,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Top section: green check + amount ──
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF4CAF50),
                    size: 38,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'R$amount.00 ZAR',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF232323),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Transaction details card ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              children: [
                _TxRow(
                  icon: Icons.account_balance_outlined,
                  label: 'From Account',
                  value: 'Current Account',
                  sub: 'R190.00 ZAR',
                ),
                const _TxDivider(),
                const _TxRow(
                  icon: Icons.person_outline_rounded,
                  label: 'To',
                  value: '1 recipient',
                ),
                const _TxDivider(),
                const _TxRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date & Time',
                  value: '20 June 2025, 20:48 PM',
                ),
                const _TxDivider(),
                _TxRow(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Status',
                  value: 'Successful',
                  valueColor: const Color(0xFF4CAF50),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Send Money Again button ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSendAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B3C),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Send Money Again',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Recent transaction chip ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                children: [
                  // Red left bar
                  Container(
                    width: 4,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B3C),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['number'] as String,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF232323),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'R100.00 ZAR',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: contact['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        contact['initials'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Support note ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '*For assistance, please contact us on 0116810532',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: const Color(0xFF999999),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // ── Back to Wallet ──
          TextButton(
            onPressed: onBackToWallet,
            child: const Text(
              'Back to Wallet',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF3B3C),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  final Color? valueColor;

  const _TxRow({
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFBBBBBB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        valueColor ?? const Color(0xFF232323),
                  ),
                ),
                if (sub != null && sub!.isNotEmpty)
                  Text(
                    sub!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xFF999999),
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

class _TxDivider extends StatelessWidget {
  const _TxDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1, thickness: 1, color: Color(0xFFF5F5F5));
  }
}