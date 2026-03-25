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
// CONTACT MODEL
// ─────────────────────────────────────────────
class _Contact {
  final String id, name, handle, initials;
  final Color color;
  const _Contact({required this.id, required this.name, required this.handle, required this.initials, required this.color});
}

const _recentContacts = [
  _Contact(id:'c1', name:'Sipho M.', handle:'@sipho.m', initials:'SM', color:Color(0xFF3B82F6)),
  _Contact(id:'c2', name:'Aisha K.', handle:'@aisha.k', initials:'AK', color:Color(0xFF10B981)),
  _Contact(id:'c3', name:'Keanu N.', handle:'@keanu.n', initials:'KN', color:Color(0xFF8B5CF6)),
  _Contact(id:'c4', name:'Priya S.', handle:'@priya.s', initials:'PS', color:Color(0xFFF59E0B)),
];

// ─────────────────────────────────────────────
// SEND MONEY SCREEN
// ─────────────────────────────────────────────
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  // Existing contact or manual entry
  _Contact? _selectedContact;
  bool _useManualEntry = false;

  final _manualNameCtrl    = TextEditingController();
  final _manualHandleCtrl  = TextEditingController();
  final _amountCtrl        = TextEditingController();
  final _noteCtrl          = TextEditingController();
  final _searchCtrl        = TextEditingController();

  String _searchQuery = '';
  int _step = 0; // 0=pick recipient  1=amount  2=confirm  3=success

  @override
  void dispose() {
    _manualNameCtrl.dispose();
    _manualHandleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Contact> get _filteredContacts => _searchQuery.isEmpty
    ? _recentContacts
    : _recentContacts.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || c.handle.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  String get _recipientName {
    if (_useManualEntry) return _manualNameCtrl.text.trim().isEmpty ? 'New Contact' : _manualNameCtrl.text.trim();
    return _selectedContact?.name ?? '';
  }

  bool get _canProceedStep0 {
    if (_useManualEntry) return _manualNameCtrl.text.trim().isNotEmpty;
    return _selectedContact != null;
  }

  bool get _canProceedStep1 {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    return amount > 0;
  }

  void _send() => setState(() => _step = 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(
          icon: Icon(_step > 0 && _step < 3 ? Icons.arrow_back_ios_rounded : Icons.close_rounded, color: _C.dark, size: 18),
          onPressed: () {
            if (_step > 0 && _step < 3) { setState(() => _step--); }
            else { context.pop(); }
          },
        ),
        title: Text(['Send Money', 'Enter Amount', 'Confirm', 'Done'][_step], style: const TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)),
        centerTitle: true,
        bottom: _step < 3 ? PreferredSize(preferredSize: const Size.fromHeight(4), child: _StepIndicator(current: _step, total: 3)) : null,
      ),
      body: [_step0(), _step1(), _step2(), _step3()][_step],
    );
  }

  // ── STEP 0: Choose recipient ─────────────────────────
  Widget _step0() => Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // ── Search existing contacts ────────────────────
      Container(height: 44, decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
        child: TextField(controller: _searchCtrl, onChanged: (v) => setState(() => _searchQuery = v),
          decoration: const InputDecoration(hintText: 'Search Gude users…', hintStyle: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)), prefixIcon: Icon(Icons.search, color: _C.grey, size: 18), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 13)))),

      const SizedBox(height: 20),

      // ── Toggle: search vs manual entry ─────────────
      Row(children: [
        Expanded(child: GestureDetector(onTap: () => setState(() { _useManualEntry = false; _selectedContact = null; }),
          child: _ToggleTab(label: 'Search users', icon: Icons.person_search_outlined, selected: !_useManualEntry))),
        const SizedBox(width: 10),
        Expanded(child: GestureDetector(onTap: () => setState(() { _useManualEntry = true; _selectedContact = null; }),
          child: _ToggleTab(label: 'Add manually', icon: Icons.edit_outlined, selected: _useManualEntry))),
      ]),

      const SizedBox(height: 20),

      if (_useManualEntry) ...[
        // ── Manual contact entry ──────────────────────
        const Text('Recipient Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
        const SizedBox(height: 6),
        const Text('Enter the name and Gude handle or phone number of the person you want to send money to.', style: TextStyle(fontSize: 12, color: _C.grey, height: 1.4)),
        const SizedBox(height: 16),

        _label('Full Name *'),
        const SizedBox(height: 6),
        _inputField(controller: _manualNameCtrl, hint: 'e.g. John Dlamini', icon: Icons.person_outline_rounded, onChanged: () => setState(() {})),
        const SizedBox(height: 14),

        _label('Gude Handle or Phone Number *'),
        const SizedBox(height: 6),
        _inputField(controller: _manualHandleCtrl, hint: '@handle or 071 234 5678', icon: Icons.alternate_email_rounded),
        const SizedBox(height: 8),

        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5))),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 16),
            SizedBox(width: 8),
            Expanded(child: Text('Make sure the handle or number is correct. Payments cannot be reversed once sent.', style: TextStyle(fontSize: 11, color: Color(0xFF92400E), height: 1.4))),
          ])),
      ] else ...[
        // ── Recent contacts ───────────────────────────
        const Text('Recent Contacts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
        const SizedBox(height: 12),

        if (_filteredContacts.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No contacts found', style: TextStyle(color: _C.grey))))
        else
          ..._filteredContacts.map((c) => GestureDetector(
            onTap: () => setState(() => _selectedContact = c),
            child: AnimatedContainer(duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedContact?.id == c.id ? _C.primary.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _selectedContact?.id == c.id ? _C.primary : _C.border, width: _selectedContact?.id == c.id ? 1.8 : 1),
              ),
              child: Row(children: [
                CircleAvatar(radius: 22, backgroundColor: c.color.withOpacity(0.15),
                  child: Text(c.initials, style: TextStyle(color: c.color, fontWeight: FontWeight.w700, fontSize: 13))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
                  Text(c.handle, style: const TextStyle(fontSize: 12, color: _C.grey)),
                ])),
                if (_selectedContact?.id == c.id)
                  Container(width: 22, height: 22, decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.white)),
              ]),
            ),
          )),
      ],
    ]))),

    // ── CTA ────────────────────────────────────────────
    Container(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), color: Colors.white, child: SizedBox(width: double.infinity, child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: _canProceedStep0 ? _C.primary : const Color(0xFFDDDDDD), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), elevation: _canProceedStep0 ? 4 : 0, shadowColor: _C.primary.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      onPressed: _canProceedStep0 ? () => setState(() => _step = 1) : null,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_canProceedStep0 ? 'Continue to Amount' : 'Select a recipient', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        if (_canProceedStep0) ...[const SizedBox(width: 8), const Icon(Icons.arrow_forward_rounded, size: 18)],
      ]),
    ))),
  ]);

  // ── STEP 1: Enter amount ─────────────────────────────
  Widget _step1() => Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // Recipient summary
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12)), child: Row(children: [
        CircleAvatar(radius: 20, backgroundColor: _C.primary.withOpacity(0.15), child: Text(_recipientName.isNotEmpty ? _recipientName[0].toUpperCase() : 'U', style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w700))),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Sending to', style: TextStyle(fontSize: 11, color: _C.grey)),
          Text(_recipientName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
        ]),
      ])),

      const SizedBox(height: 28),

      // Amount input (large)
      Center(child: Column(children: [
        const Text('Amount', style: TextStyle(fontSize: 13, color: _C.grey)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('R', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: _C.dark)),
          const SizedBox(width: 4),
          IntrinsicWidth(child: TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), textAlign: TextAlign.center, onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: _C.dark),
            decoration: const InputDecoration(hintText: '0', hintStyle: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFFDDDDDD)), border: InputBorder.none))),
        ]),
        Text('Available: R${(2800 - 200).toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: _C.grey)),
      ])),

      const SizedBox(height: 28),

      // Quick amounts
      Wrap(spacing: 8, runSpacing: 8, children: ['50', '100', '200', '500', '1000'].map((a) =>
        GestureDetector(onTap: () => setState(() => _amountCtrl.text = a),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: _amountCtrl.text == a ? _C.primary.withOpacity(0.1) : _C.lightGrey, borderRadius: BorderRadius.circular(20), border: Border.all(color: _amountCtrl.text == a ? _C.primary : _C.border)),
            child: Text('R$a', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _amountCtrl.text == a ? _C.primary : _C.dark))))).toList()),

      const SizedBox(height: 20),

      _label('Note (optional)'),
      const SizedBox(height: 6),
      _inputField(controller: _noteCtrl, hint: 'e.g. Lunch money', icon: Icons.note_outlined),
    ]))),
    Container(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), color: Colors.white, child: SizedBox(width: double.infinity, child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: _canProceedStep1 ? _C.primary : const Color(0xFFDDDDDD), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), elevation: _canProceedStep1 ? 4 : 0, shadowColor: _C.primary.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      onPressed: _canProceedStep1 ? () => setState(() => _step = 2) : null,
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Review Transfer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        SizedBox(width: 8), Icon(Icons.arrow_forward_rounded, size: 18),
      ]),
    ))),
  ]);

  // ── STEP 2: Confirm ──────────────────────────────────
  Widget _step2() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    return Column(children: [
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(16)), child: Column(children: [
          const Text('Transfer Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
          const SizedBox(height: 16),
          _summaryRow('To', _recipientName),
          _summaryRow('Amount', 'R${amount.toStringAsFixed(2)}'),
          _summaryRow('Fee', 'R0.00'),
          const Divider(height: 20),
          _summaryRow('Total', 'R${amount.toStringAsFixed(2)}', bold: true),
          if (_noteCtrl.text.isNotEmpty) _summaryRow('Note', _noteCtrl.text),
        ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5))),
          child: const Row(children: [
            Icon(Icons.lock_outline_rounded, color: Color(0xFFF59E0B), size: 18),
            SizedBox(width: 8),
            Expanded(child: Text('This transfer is secured and cannot be reversed once sent. Please review carefully.', style: TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4))),
          ])),
      ]))),
      Container(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), color: Colors.white, child: SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _C.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), elevation: 4, shadowColor: _C.primary.withOpacity(0.4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        onPressed: _send,
        child: Text('Send R${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ))),
    ]);
  }

  // ── STEP 3: Success ──────────────────────────────────
  Widget _step3() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    return SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(flex: 2),
      Container(width: 110, height: 110, decoration: const BoxDecoration(color: Color(0xFFF0FFF4), shape: BoxShape.circle),
        child: Center(child: Icon(Icons.check_circle_rounded, size: 64, color: _C.green))),
      const SizedBox(height: 24),
      const Text('Transfer Successful!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _C.dark)),
      const SizedBox(height: 8),
      Text('R${amount.toStringAsFixed(2)} has been sent to $_recipientName.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: _C.grey, height: 1.5)),
      const Spacer(flex: 3),
      SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        onPressed: () => context.go('/wallet'),
        child: const Text('Back to Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
      )),
    ])));
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.grey));

  Widget _inputField({required TextEditingController controller, required String hint, required IconData icon, VoidCallback? onChanged}) =>
    TextFormField(controller: controller, onChanged: (_) => onChanged?.call(),
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _C.dark),
      decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13), prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB), size: 20), filled: true, fillColor: const Color(0xFFFAFAFA), contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.primary, width: 1.5))));

  Widget _summaryRow(String label, String value, {bool bold = false}) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontSize: 13, color: bold ? _C.dark : _C.grey, fontWeight: bold ? FontWeight.w700 : FontWeight.normal)),
    Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: bold ? _C.primary : _C.dark)),
  ]));
}

// ─────────────────────────────────────────────
// TOGGLE TAB
// ─────────────────────────────────────────────
class _ToggleTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _ToggleTab({required this.label, required this.icon, required this.selected});
  @override
  Widget build(BuildContext context) => AnimatedContainer(duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: selected ? const Color(0xFFE30613).withOpacity(0.07) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? const Color(0xFFE30613) : const Color(0xFFEEEEEE), width: selected ? 1.8 : 1)),
    child: Column(children: [
      Icon(icon, color: selected ? const Color(0xFFE30613) : const Color(0xFF888888), size: 20),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? const Color(0xFFE30613) : const Color(0xFF888888))),
    ]));
}

// ─────────────────────────────────────────────
// STEP INDICATOR
// ─────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current, total;
  const _StepIndicator({required this.current, required this.total});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6), child: Row(children: List.generate(total, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 3, decoration: BoxDecoration(color: i <= current ? const Color(0xFFE30613) : const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(2)))))));
}