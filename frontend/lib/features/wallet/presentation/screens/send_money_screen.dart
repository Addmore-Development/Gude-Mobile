import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

// ─────────────────────────────────────────────────────────────
// SEND MONEY SCREEN  (3-step flow)
// ─────────────────────────────────────────────────────────────
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  int _step = 0;

  Map<String, dynamic>? _selectedContact;
  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: _C.dark, size: 18),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Text(
          ['Send Money', 'Payment Details', 'Confirm'][_step],
          style: const TextStyle(
              color: _C.dark, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          if (_step < 2)
            TextButton(
              onPressed: () => context.go('/wallet'),
              child: const Text('Cancel',
                  style: TextStyle(color: _C.grey, fontSize: 13)),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: _StepBar(current: _step, total: 3),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _SelectRecipientStep(
          key: const ValueKey(0),
          onNext: (contact) {
            setState(() {
              _selectedContact = contact;
              _step = 1;
            });
          },
        );
      case 1:
        return _PayDetailsStep(
          key: const ValueKey(1),
          contact: _selectedContact!,
          amountCtrl: _amountCtrl,
          noteCtrl: _noteCtrl,
          onNext: () => setState(() => _step = 2),
        );
      case 2:
        return _ConfirmStep(
          key: const ValueKey(2),
          contact: _selectedContact!,
          amount: double.tryParse(_amountCtrl.text) ?? 0,
          note: _noteCtrl.text,
          onSend: _handleSend,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleSend() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        contact: _selectedContact!,
        amount: double.tryParse(_amountCtrl.text) ?? 0,
        onDone: () => context.go('/wallet'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEP BAR
// ─────────────────────────────────────────────────────────────
class _StepBar extends StatelessWidget {
  final int current, total;
  const _StepBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 3),
      child: Row(
        children: List.generate(
          total,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 3,
              decoration: BoxDecoration(
                color: i <= current
                    ? const Color(0xFFE30613)
                    : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 1 — SELECT RECIPIENT
// ─────────────────────────────────────────────────────────────
class _SelectRecipientStep extends StatefulWidget {
  final void Function(Map<String, dynamic> contact) onNext;
  const _SelectRecipientStep({super.key, required this.onNext});

  @override
  State<_SelectRecipientStep> createState() => _SelectRecipientStepState();
}

class _SelectRecipientStepState extends State<_SelectRecipientStep> {
  int _mode = 0; // 0 = Contacts, 1 = Phone/Account
  Map<String, dynamic>? _selected;
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _contacts = [
    {'name': 'Vanessa Top',     'number': '071 234 5678', 'initials': 'VT', 'color': Color(0xFF8B5CF6)},
    {'name': 'Paul Gabler',     'number': '082 345 6789', 'initials': 'PG', 'color': Color(0xFF3B82F6)},
    {'name': 'Mia Scott',       'number': '060 456 7890', 'initials': 'MS', 'color': Color(0xFFEC4899)},
    {'name': 'David Pred',      'number': '073 567 8901', 'initials': 'DP', 'color': Color(0xFF10B981)},
    {'name': 'Mason Margelis',  'number': '084 678 9012', 'initials': 'MM', 'color': Color(0xFFF59E0B)},
    {'name': 'Stacey Clerk',    'number': '079 789 0123', 'initials': 'SC', 'color': Color(0xFF06B6D4)},
    {'name': 'Eviss Preme',     'number': '065 890 1234', 'initials': 'EP', 'color': Color(0xFFE30613)},
    {'name': 'Shelly Given',    'number': '072 901 2345', 'initials': 'SG', 'color': Color(0xFF059669)},
  ];

  List<Map<String, dynamic>> get _filtered => _contacts
      .where((c) =>
          _query.isEmpty ||
          (c['name'] as String).toLowerCase().contains(_query.toLowerCase()) ||
          (c['number'] as String).contains(_query))
      .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              _ModeTab(
                label: 'Contacts',
                icon: Icons.contacts_rounded,
                selected: _mode == 0,
                onTap: () => setState(() => _mode = 0),
              ),
              const SizedBox(width: 10),
              _ModeTab(
                label: 'Phone / Account',
                icon: Icons.dialpad_rounded,
                selected: _mode == 1,
                onTap: () => setState(() => _mode = 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (_mode == 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _StyledTextField(
              controller: _searchCtrl,
              hint: 'Search by name or number…',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final sel = _selected?['name'] == c['name'];
                return InkWell(
                  onTap: () => setState(() => _selected = c),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: (c['color'] as Color).withOpacity(0.15),
                        child: Text(c['initials'] as String,
                            style: TextStyle(
                                color: c['color'] as Color,
                                fontWeight: FontWeight.w800,
                                fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'] as String,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _C.dark)),
                              Text(c['number'] as String,
                                  style: const TextStyle(
                                      fontSize: 12, color: _C.grey)),
                            ]),
                      ),
                      if (sel)
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFFE30613), size: 22),
                    ]),
                  ),
                );
              },
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _StyledTextField(
                hint: 'Enter phone number or account number',
                keyboardType: TextInputType.phone,
                onChanged: (_) {}),
          ),
          const Spacer(),
        ],

        // CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: _EftButton(
            onPressed: _selected != null
                ? () => widget.onNext(_selected!)
                : null,
            child: const Text('Continue',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 2 — PAYMENT DETAILS
// ─────────────────────────────────────────────────────────────
class _PayDetailsStep extends StatelessWidget {
  final Map<String, dynamic> contact;
  final TextEditingController amountCtrl;
  final TextEditingController noteCtrl;
  final VoidCallback onNext;

  const _PayDetailsStep({
    super.key,
    required this.contact,
    required this.amountCtrl,
    required this.noteCtrl,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Recipient card
        _DetailCard(
          icon: Icons.person_rounded,
          label: 'Sending to',
          title: contact['name'] as String,
          sub: contact['number'] as String,
        ),
        const SizedBox(height: 20),

        const Text('Amount',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _C.grey)),
        const SizedBox(height: 8),
        _StyledTextField(
          controller: amountCtrl,
          hint: 'R 0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefix: const Text('R ',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16, color: _C.dark)),
          onChanged: (_) {},
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
        ),
        const SizedBox(height: 20),

        const Text('Note (optional)',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _C.grey)),
        const SizedBox(height: 8),
        _StyledTextField(
          controller: noteCtrl,
          hint: 'What\'s this payment for?',
          onChanged: (_) {},
        ),
        const SizedBox(height: 32),

        _EftButton(
          onPressed: onNext,
          child: const Text('Review Payment',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STEP 3 — CONFIRM
// ─────────────────────────────────────────────────────────────
class _ConfirmStep extends StatelessWidget {
  final Map<String, dynamic> contact;
  final double amount;
  final String note;
  final VoidCallback onSend;

  const _ConfirmStep({
    super.key,
    required this.contact,
    required this.amount,
    required this.note,
    required this.onSend,
  });

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: _C.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: _C.dark)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE30613), Color(0xFF8B000A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(children: [
              const Text('You are sending',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                'R ${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1),
              ),
              const SizedBox(height: 6),
              Text('to ${contact['name']}',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 14)),
            ]),
          ),
          const SizedBox(height: 20),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.border),
            ),
            child: Column(children: [
              _summaryRow('To', contact['name'] as String),
              _summaryRow('Account', contact['number'] as String),
              _summaryRow('Amount', 'R${amount.toStringAsFixed(2)}'),
              _summaryRow('Fee', 'R0.00'),
              const Divider(height: 20),
              _summaryRow('Total', 'R${amount.toStringAsFixed(2)}', bold: true),
              if (note.isNotEmpty) _summaryRow('Note', note),
            ]),
          ),
          const SizedBox(height: 28),

          _EftButton(
            onPressed: onSend,
            child: Text(
              'Send R${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SUCCESS DIALOG
// ─────────────────────────────────────────────────────────────
class _SuccessDialog extends StatelessWidget {
  final Map<String, dynamic> contact;
  final double amount;
  final VoidCallback onDone;

  const _SuccessDialog({
    required this.contact,
    required this.amount,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF10B981), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Payment Sent!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _C.dark)),
            const SizedBox(height: 8),
            Text(
              'R${amount.toStringAsFixed(2)} has been sent to ${contact['name']}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: _C.grey, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE30613),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onDone,
                child: const Text('Back to Wallet',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// RECEIVED MONEY SCREEN
// (referenced by app_router.dart at /wallet/received)
// ─────────────────────────────────────────────────────────────
class ReceivedMoneyScreen extends StatelessWidget {
  const ReceivedMoneyScreen({super.key});

  static const _received = [
    {'name': 'James Mokoena', 'initials': 'JM', 'amount': 150.0, 'date': 'Today, 10:30'},
    {'name': 'Sipho Ndlovu',  'initials': 'SN', 'amount': 300.0, 'date': 'Yesterday, 15:42'},
    {'name': 'Amara Dube',    'initials': 'AD', 'amount': 450.0, 'date': 'Mon, 09:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: _C.dark, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Received Money',
            style: TextStyle(
                color: _C.dark,
                fontWeight: FontWeight.w800,
                fontSize: 17)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _received.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
        itemBuilder: (_, i) {
          final r = _received[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                child: Text(r['initials'] as String,
                    style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w800,
                        fontSize: 13)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['name'] as String,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _C.dark)),
                      Text(r['date'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: _C.grey)),
                    ]),
              ),
              Text('+R${(r['amount'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10B981))),
            ]),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────

// ── Primary button ────────────────────────────────────────────
class _EftButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const _EftButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE30613),
          disabledBackgroundColor: const Color(0xFFDDDDDD),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onPressed,
        child: DefaultTextStyle(
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700),
          child: child,
        ),
      ),
    );
  }
}

// ── Styled text field ─────────────────────────────────────────
class _StyledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;

  const _StyledTextField({
    this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.prefix,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: _C.dark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
        prefix: prefix,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE30613), width: 1.5),
        ),
      ),
    );
  }
}

// ── Detail card (recipient etc.) ──────────────────────────────
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
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFE30613).withOpacity(0.2)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE30613).withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFFE30613)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: _C.grey)),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                if (sub.isNotEmpty)
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 12, color: _C.grey)),
              ]),
        ),
      ]),
    );
  }
}

// ── Mode tab ──────────────────────────────────────────────────
class _ModeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE30613).withOpacity(0.07)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFFE30613)
                  : const Color(0xFFEEEEEE),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected
                      ? const Color(0xFFE30613)
                      : const Color(0xFF888888)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFFE30613)
                          : const Color(0xFF888888)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}