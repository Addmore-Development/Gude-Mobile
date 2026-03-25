import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// ─────────────────────────────────────────────────────────────────────────────
// SEND MONEY PAGE
// Step 0 → Select Recipient (Contact list, sort, add contact)
// Step 1 → Pay Details (from/to, amount, EFT type, reference)
// Step 2 → Transaction Details / Success
// ─────────────────────────────────────────────────────────────────────────────


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
  int _step = 0;
  int _selectedContact = -1;
  bool _immediate = false;
  String _sortBy = 'Recent'; // 'Recent', 'Most Sent', 'A-Z'
  // Existing contact or manual entry
  _Contact? _selectedContact;
  bool _useManualEntry = false;

  final _amountController = TextEditingController();
  final _refController = TextEditingController();

  // Contact list with additional fields for sorting
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
      'lastSentDate': DateTime.now().subtract(const Duration(days: 0, hours: 3)),
      'totalSent': 75.0,
    },
  ];

  // Sorted list based on _sortBy
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
      default:
        break;
    }
    return list;
  }
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

  // Show dialog to add new contact
  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Contact', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., John Doe',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: numberController,
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
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF999999))),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final number = numberController.text.trim();
              if (name.isNotEmpty && number.isNotEmpty) {
                final initials = name.split(' ').map((e) => e[0]).join().toUpperCase();
                // Generate a random color from a list
                final colors = [0xFFE91E63, 0xFF4CAF50, 0xFF9C27B0, 0xFF3F51B5, 0xFFFF9800, 0xFF00BCD4];
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF3B3C)),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _send() => setState(() => _step = 3);

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
                contacts: _sortedContacts,
                selected: _selectedContact,
                sortBy: _sortBy,
                onSortChange: (value) => setState(() => _sortBy = value),
                onSelect: (i) => setState(() => _selectedContact = i),
                onCancel: () => context.go('/wallet'),
                onBack: () => context.go('/wallet'),
                onContinue: _selectedContact >= 0
                    ? () => setState(() => _step = 1)
                    : null,
                onAddContact: _showAddContactDialog,
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
      floatingActionButton: _step == 0
          ? FloatingActionButton(
              onPressed: _showAddContactDialog,
              backgroundColor: const Color(0xFFFF3B3C),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF232323)),
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          height: 3,
          color: const Color(0xFFFF3B3C),
        ),
      ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 0 — SELECT RECIPIENT
// ─────────────────────────────────────────────────────────────────────────────

class _SelectRecipientStep extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final int selected;
  final String sortBy;
  final void Function(String) onSortChange;
  final void Function(int) onSelect;
  final VoidCallback onCancel;
  final VoidCallback onBack;
  final VoidCallback? onContinue;
  final VoidCallback onAddContact;

  const _SelectRecipientStep({
    super.key,
    required this.contacts,
    required this.selected,
    required this.sortBy,
    required this.onSortChange,
    required this.onSelect,
    required this.onCancel,
    required this.onBack,
    required this.onContinue,
    required this.onAddContact,
  });

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Recent', style: TextStyle(fontFamily: 'Poppins')),
            trailing: sortBy == 'Recent' ? const Icon(Icons.check, color: Color(0xFFFF3B3C)) : null,
            onTap: () {
              onSortChange('Recent');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Most Sent', style: TextStyle(fontFamily: 'Poppins')),
            trailing: sortBy == 'Most Sent' ? const Icon(Icons.check, color: Color(0xFFFF3B3C)) : null,
            onTap: () {
              onSortChange('Most Sent');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('A-Z', style: TextStyle(fontFamily: 'Poppins')),
            trailing: sortBy == 'A-Z' ? const Icon(Icons.check, color: Color(0xFFFF3B3C)) : null,
            onTap: () {
              onSortChange('A-Z');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

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

  // ── STEP 0: Choose recipient ─────────────────────────
  Widget _step0() => Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // ── Search existing contacts ────────────────────
      Container(height: 44, decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
        child: TextField(controller: _searchCtrl, onChanged: (v) => setState(() => _searchQuery = v),
          decoration: const InputDecoration(hintText: 'Search Gude users…', hintStyle: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)), prefixIcon: Icon(Icons.search, color: _C.grey, size: 18), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 13)))),

      const SizedBox(height: 20),

              // Sort By row
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
                  GestureDetector(
                    onTap: () => _showSortOptions(context),
                    child: Row(
                      children: [
                        Text(
                          sortBy,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFFFF3B3C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Color(0xFFFF3B3C)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

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

        // Contact List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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

        // Bottom Buttons
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

// ─────────────────────────────────────────────────────────────────────────────
// CONTACT TILE (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            Container(
              width: 44,
              height: 44,
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
// STEP 1 — PAY DETAILS (unchanged)
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
          _DetailCard(
            icon: Icons.account_balance_outlined,
            label: 'From Account',
            title: 'Current Balance',
            sub: 'R190.00 ZAR',
          ),
          const SizedBox(height: 12),
          _DetailCard(
            icon: Icons.person_outline_rounded,
            label: 'To',
            title: contact['name'] as String,
            sub: contact['number'] as String,
          ),
          const SizedBox(height: 20),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
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
            child: Icon(icon, size: 18, color: const Color(0xFFFF3B3C)),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF3B3C), width: 1.5),
        ),
      ),
    );
  }
}

class _EftButton extends StatelessWidget {

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
            color: selected ? const Color(0xFFFF3B3C) : const Color(0xFFDDDDDD),
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
                  ? (isOutlined ? const Color(0xFFFF3B3C) : Colors.white)
                  : const Color(0xFF999999),
            ),
          ),
        ),
      ),
    );
  }
  Widget build(BuildContext context) => AnimatedContainer(duration: const Duration(milliseconds: 200),
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(color: selected ? const Color(0xFFE30613).withOpacity(0.07) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12), border: Border.all(color: selected ? const Color(0xFFE30613) : const Color(0xFFEEEEEE), width: selected ? 1.8 : 1)),
    child: Column(children: [
      Icon(icon, color: selected ? const Color(0xFFE30613) : const Color(0xFF888888), size: 20),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? const Color(0xFFE30613) : const Color(0xFF888888))),
    ]));
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2 — TRANSACTION DETAILS / SUCCESS (unchanged)
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

// ─────────────────────────────────────────────
// STEP INDICATOR
// ─────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current, total;
  const _StepIndicator({required this.current, required this.total});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                    color: valueColor ?? const Color(0xFF232323),
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
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5));
  }
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6), child: Row(children: List.generate(total, (i) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 3, decoration: BoxDecoration(color: i <= current ? const Color(0xFFE30613) : const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(2)))))));
}