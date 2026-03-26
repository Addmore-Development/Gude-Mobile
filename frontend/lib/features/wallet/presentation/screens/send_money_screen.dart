import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

// ─────────────────────────────────────────────
// SEND MONEY SCREEN
// Steps: 0=Select Recipient  1=Enter Amount  2=Confirm  3=Success
// ─────────────────────────────────────────────
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  int _step = 0;

  // Contact list
  List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Susan Precious',
      'number': '+2769335215',
      'initials': 'SP',
      'color': const Color(0xFFE91E63),
      'lastSentDate': DateTime.now().subtract(const Duration(days: 1)),
      'totalSent': 450.0,
    },
    {
      'name': 'Kinalwe Hope',
      'number': '+2761234567',
      'initials': 'KH',
      'color': const Color(0xFF4CAF50),
      'lastSentDate': DateTime.now().subtract(const Duration(days: 5)),
      'totalSent': 1200.0,
    },
    {
      'name': 'Pearl Hlogwane',
      'number': '+2769876543',
      'initials': 'PH',
      'color': const Color(0xFF9C27B0),
      'lastSentDate': DateTime.now().subtract(const Duration(days: 2)),
      'totalSent': 300.0,
    },
    {
      'name': 'Thabo Mbeki',
      'number': '+2761234578',
      'initials': 'TM',
      'color': const Color(0xFF3F51B5),
      'lastSentDate': DateTime.now().subtract(const Duration(hours: 3)),
      'totalSent': 75.0,
    },
  ];

  int _selectedContactIndex = -1;
  String _sortBy = 'Recent';

  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _sortedContacts {
    final list = List<Map<String, dynamic>>.from(_contacts);
    switch (_sortBy) {
      case 'Recent':
        list.sort((a, b) => (b['lastSentDate'] as DateTime).compareTo(a['lastSentDate'] as DateTime));
        break;
      case 'Most Sent':
        list.sort((a, b) => (b['totalSent'] as double).compareTo(a['totalSent'] as double));
        break;
      case 'A-Z':
        list.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        break;
    }
    return list;
  }

  List<Map<String, dynamic>> get _filteredContacts {
    final sorted = _sortedContacts;
    if (_searchQuery.isEmpty) return sorted;
    return sorted.where((c) =>
      (c['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (c['number'] as String).contains(_searchQuery)
    ).toList();
  }

  bool get _canProceedStep0 => _selectedContactIndex >= 0;

  bool get _canProceedStep1 {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    return amount > 0;
  }

  Map<String, dynamic>? get _selectedContact =>
      _selectedContactIndex >= 0 ? _contacts[_selectedContactIndex] : null;

  void _send() => setState(() => _step = 3);

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Recent', 'Most Sent', 'A-Z'].map((option) => ListTile(
          title: Text(option),
          trailing: _sortBy == option
              ? const Icon(Icons.check, color: _C.primary)
              : null,
          onTap: () {
            setState(() => _sortBy = option);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    );
  }

  void _showAddContactDialog() {
    final nameCtrl   = TextEditingController();
    final numberCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Contact',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                hintText: 'e.g. John Doe',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numberCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                hintText: '+27 12 345 6789',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF999999))),
          ),
          ElevatedButton(
            onPressed: () {
              final name   = nameCtrl.text.trim();
              final number = numberCtrl.text.trim();
              if (name.isNotEmpty && number.isNotEmpty) {
                final initials = name
                    .split(' ')
                    .where((e) => e.isNotEmpty)
                    .map((e) => e[0])
                    .join()
                    .toUpperCase();
                final colors = [
                  0xFFE91E63, 0xFF4CAF50, 0xFF9C27B0,
                  0xFF3F51B5, 0xFFFF9800, 0xFF00BCD4
                ];
                final color = Color(colors[_contacts.length % colors.length]);
                setState(() {
                  _contacts.add({
                    'name': name,
                    'number': number,
                    'initials': initials,
                    'color': color,
                    'lastSentDate': DateTime.now(),
                    'totalSent': 0.0,
                  });
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in both fields')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _C.primary),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Shared helper widgets ─────────────────────────────────
  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: _C.grey),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    VoidCallback? onChanged,
    TextInputType? keyboardType,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: (_) => onChanged?.call(),
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: _C.dark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
          prefixIcon:
              Icon(icon, color: const Color(0xFFBBBBBB), size: 20),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.primary, width: 1.5)),
        ),
      );

  Widget _summaryRow(String label, String value, {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: bold ? _C.dark : _C.grey,
                    fontWeight:
                        bold ? FontWeight.w700 : FontWeight.normal)),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        bold ? FontWeight.w800 : FontWeight.w600,
                    color: bold ? _C.primary : _C.dark)),
          ],
        ),
      );

  // ─────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _step > 0 && _step < 3
                ? Icons.arrow_back_ios_rounded
                : Icons.close_rounded,
            color: _C.dark,
            size: 18,
          ),
          onPressed: () {
            if (_step > 0 && _step < 3) {
              setState(() => _step--);
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          ['Send Money', 'Enter Amount', 'Confirm', 'Done'][_step],
          style: const TextStyle(
              color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        centerTitle: true,
        bottom: _step < 3
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: _StepIndicator(current: _step, total: 3))
            : null,
      ),
      floatingActionButton: _step == 0
          ? FloatingActionButton(
              onPressed: _showAddContactDialog,
              backgroundColor: _C.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: [_step0(), _step1(), _step2(), _step3()][_step],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // STEP 0 — Select Recipient
  // ─────────────────────────────────────────────────────────
  Widget _step0() => Column(
        key: const ValueKey(0),
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Who do you want to\nsend money to?',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _C.dark,
                        height: 1.3),
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: _C.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.border)),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Search contacts…',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Color(0xFFAAAAAA)),
                        prefixIcon:
                            Icon(Icons.search, color: _C.grey, size: 18),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sort row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Contact Names',
                          style:
                              TextStyle(fontSize: 12, color: _C.grey)),
                      GestureDetector(
                        onTap: _showSortOptions,
                        child: Row(children: [
                          Text(_sortBy,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: _C.primary,
                                  fontWeight: FontWeight.w500)),
                          const Icon(Icons.arrow_drop_down,
                              color: _C.primary),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Contact list
                  if (_filteredContacts.isEmpty)
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('No contacts found',
                                style: TextStyle(color: _C.grey))))
                  else
                    ..._filteredContacts.map((c) {
                      // Find original index in _contacts
                      final origIdx = _contacts.indexOf(c);
                      final isSelected = _selectedContactIndex == origIdx;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedContactIndex = origIdx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _C.primary.withOpacity(0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: isSelected
                                    ? _C.primary
                                    : _C.border,
                                width: isSelected ? 1.8 : 1),
                          ),
                          child: Row(children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  (c['color'] as Color).withOpacity(0.15),
                              child: Text(c['initials'] as String,
                                  style: TextStyle(
                                      color: c['color'] as Color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name'] as String,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: _C.dark)),
                                    Text(c['number'] as String,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: _C.grey)),
                                  ]),
                            ),
                            if (isSelected)
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                    color: _C.primary,
                                    shape: BoxShape.circle),
                                child: const Icon(Icons.check,
                                    size: 12, color: Colors.white),
                              ),
                          ]),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),

          // CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canProceedStep0
                      ? _C.primary
                      : const Color(0xFFDDDDDD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: _canProceedStep0 ? 4 : 0,
                  shadowColor: _C.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _canProceedStep0
                    ? () => setState(() => _step = 1)
                    : null,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          _canProceedStep0
                              ? 'Continue to Amount'
                              : 'Select a recipient',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      if (_canProceedStep0) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ]),
              ),
            ),
          ),
        ],
      );

  // ─────────────────────────────────────────────────────────
  // STEP 1 — Enter Amount
  // ─────────────────────────────────────────────────────────
  Widget _step1() {
    final contact = _selectedContact!;
    return Column(
      key: const ValueKey(1),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipient summary chip
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _C.primary.withOpacity(0.15),
                      child: Text(
                          (contact['name'] as String).isNotEmpty
                              ? (contact['name'] as String)[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              color: _C.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sending to',
                              style: TextStyle(
                                  fontSize: 11, color: _C.grey)),
                          Text(contact['name'] as String,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _C.dark)),
                        ]),
                  ]),
                ),
                const SizedBox(height: 28),

                // Large amount input
                Center(
                  child: Column(children: [
                    const Text('Amount',
                        style: TextStyle(fontSize: 13, color: _C.grey)),
                    const SizedBox(height: 8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('R',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: _C.dark)),
                          const SizedBox(width: 4),
                          IntrinsicWidth(
                            child: TextField(
                              controller: _amountCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textAlign: TextAlign.center,
                              onChanged: (_) => setState(() {}),
                              style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: _C.dark),
                              decoration: const InputDecoration(
                                hintText: '0',
                                hintStyle: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFDDDDDD)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ]),
                    const Text('Available: R2 600.00',
                        style: TextStyle(fontSize: 12, color: _C.grey)),
                  ]),
                ),
                const SizedBox(height: 28),

                // Quick amounts
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['50', '100', '200', '500', '1000']
                      .map((a) => GestureDetector(
                            onTap: () =>
                                setState(() => _amountCtrl.text = a),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: _amountCtrl.text == a
                                    ? _C.primary.withOpacity(0.1)
                                    : _C.lightGrey,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: _amountCtrl.text == a
                                        ? _C.primary
                                        : _C.border),
                              ),
                              child: Text('R$a',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _amountCtrl.text == a
                                          ? _C.primary
                                          : _C.dark)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),

                _label('Note (optional)'),
                const SizedBox(height: 6),
                _inputField(
                    controller: _noteCtrl,
                    hint: 'e.g. Lunch money',
                    icon: Icons.note_outlined),
              ],
            ),
          ),
        ),

        // CTA
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _canProceedStep1
                    ? _C.primary
                    : const Color(0xFFDDDDDD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: _canProceedStep1 ? 4 : 0,
                shadowColor: _C.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _canProceedStep1
                  ? () => setState(() => _step = 2)
                  : null,
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Review Transfer',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // STEP 2 — Confirm
  // ─────────────────────────────────────────────────────────
  Widget _step2() {
    final contact = _selectedContact!;
    final amount  = double.tryParse(_amountCtrl.text) ?? 0;
    final recipientName = contact['name'] as String;

    return Column(
      key: const ValueKey(2),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: _C.lightGrey,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  const Text('Transfer Summary',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _C.dark)),
                  const SizedBox(height: 16),
                  _summaryRow('To', recipientName),
                  _summaryRow('Amount',
                      'R${amount.toStringAsFixed(2)}'),
                  _summaryRow('Fee', 'R0.00'),
                  const Divider(height: 20),
                  _summaryRow(
                      'Total', 'R${amount.toStringAsFixed(2)}',
                      bold: true),
                  if (_noteCtrl.text.isNotEmpty)
                    _summaryRow('Note', _noteCtrl.text),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.5)),
                ),
                child: const Row(children: [
                  Icon(Icons.lock_outline_rounded,
                      color: Color(0xFFF59E0B), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    'This transfer is secured and cannot be reversed once sent. Please review carefully.',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF92400E),
                        height: 1.4),
                  )),
                ]),
              ),
            ]),
          ),
        ),

        // CTA
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: _C.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _send,
              child: Text(
                  'Send R${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // STEP 3 — Success
  // ─────────────────────────────────────────────────────────
  Widget _step3() {
    final contact = _selectedContact!;
    final amount  = double.tryParse(_amountCtrl.text) ?? 0;
    final recipientName = contact['name'] as String;

    return SafeArea(
      key: const ValueKey(3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 24),
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
                color: Color(0xFFF0FFF4), shape: BoxShape.circle),
            child: const Center(
                child: Icon(Icons.check_circle_rounded,
                    size: 64, color: _C.green)),
          ),
          const SizedBox(height: 24),
          const Text('Transfer Successful!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: _C.dark)),
          const SizedBox(height: 8),
          Text(
              'R${amount.toStringAsFixed(2)} has been sent to $recipientName.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: _C.grey, height: 1.5)),
          const SizedBox(height: 32),

          // Transaction detail card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border),
            ),
            child: Column(children: [
              _TxRow(
                icon: Icons.account_balance_outlined,
                label: 'From Account',
                value: 'Current Account',
                sub: 'R2 600.00 ZAR',
              ),
              const _TxDivider(),
              _TxRow(
                  icon: Icons.person_outline_rounded,
                  label: 'To',
                  value: recipientName),
              const _TxDivider(),
              _TxRow(
                  icon: Icons.monetization_on_outlined,
                  label: 'Amount',
                  value: 'R${amount.toStringAsFixed(2)} ZAR'),
              const _TxDivider(),
              const _TxRow(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Status',
                  value: 'Successful',
                  valueColor: _C.green),
            ]),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              onPressed: () {
                setState(() {
                  _step = 0;
                  _selectedContactIndex = -1;
                  _amountCtrl.clear();
                  _noteCtrl.clear();
                });
              },
              child: const Text('Send Money Again',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.go('/wallet'),
            child: const Text('Back to Wallet',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.primary)),
          ),
          const SizedBox(height: 8),
          const Text('*For assistance, please contact us on 0116810532',
              style: TextStyle(
                  fontSize: 11,
                  color: _C.grey,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP INDICATOR
// ─────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current, total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
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

// ─────────────────────────────────────────────
// TRANSACTION ROW (used on success screen)
// ─────────────────────────────────────────────
class _TxRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(icon, size: 18, color: const Color(0xFFBBBBBB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF999999))),
                  const SizedBox(height: 2),
                  Text(value,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: valueColor ?? const Color(0xFF232323))),
                  if (sub != null && sub!.isNotEmpty)
                    Text(sub!,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF999999))),
                ]),
          ),
        ]),
      );
}

class _TxDivider extends StatelessWidget {
  const _TxDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5));
}