import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
}

// ─────────────────────────────────────────────
// CREATE POST PAGE
// ─────────────────────────────────────────────
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
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
          icon: const Icon(Icons.arrow_back, color: _C.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create a Post',
          style: TextStyle(
              color: _C.dark, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: _C.grey),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: _C.primary,
          unselectedLabelColor: _C.grey,
          indicatorColor: _C.primary,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Sell Items'),
            Tab(text: 'Offer Services'),
            Tab(text: 'Ride-Buddy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _SellItemsForm(),
          _OfferServicesForm(),
          _RideBuddyForm(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SELL ITEMS FORM
// ─────────────────────────────────────────────
class _SellItemsForm extends StatefulWidget {
  const _SellItemsForm();

  @override
  State<_SellItemsForm> createState() => _SellItemsFormState();
}

class _SellItemsFormState extends State<_SellItemsForm> {
  final _titleCtrl       = TextEditingController();
  final _descCtrl        = TextEditingController();
  final _priceCtrl       = TextEditingController();
  final _locationCtrl    = TextEditingController();
  final _serialCtrl      = TextEditingController();
  final _linkCtrl        = TextEditingController();
  String _selectedCategory = 'Electronics';
  String _selectedCondition = 'Good';
  final List<XFile> _pickedImages = [];
  final _picker = ImagePicker();

  static const _categories = [
    'Electronics', 'Furniture', 'Books', 'Stationery',
    'Clothes', 'Bags', 'Appliances', 'Other',
  ];
  static const _conditions = ['New', 'Like New', 'Good', 'Fair'];

  Future<void> _pickImages() async {
    final imgs = await _picker.pickMultiImage(imageQuality: 80);
    if (imgs.isNotEmpty) {
      setState(() => _pickedImages.addAll(imgs));
    }
  }

  void _removeImage(int i) => setState(() => _pickedImages.removeAt(i));

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in Title and Price'),
          backgroundColor: _C.primary,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listing submitted successfully! 🎉'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _locationCtrl.dispose();
    _serialCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image upload ──
          _sectionLabel('Product Images'),
          const SizedBox(height: 8),
          SizedBox(
            height: 86,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Existing picked images
                ..._pickedImages.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(e.value.path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2, right: 2,
                          child: GestureDetector(
                            onTap: () => _removeImage(e.key),
                            child: Container(
                              width: 18, height: 18,
                              decoration: const BoxDecoration(
                                color: _C.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Upload button
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _C.border, style: BorderStyle.solid),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            color: _C.grey, size: 28),
                        SizedBox(height: 4),
                        Text('Upload',
                            style:
                                TextStyle(color: _C.grey, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose a File or Drag And Drop it Here',
            style: TextStyle(color: _C.grey, fontSize: 11),
          ),

          const SizedBox(height: 16),

          // ── Title ──
          _sectionLabel('Title'),
          const SizedBox(height: 6),
          _inputField(_titleCtrl, 'Add title'),

          const SizedBox(height: 12),

          // ── Description ──
          _sectionLabel('Description'),
          const SizedBox(height: 6),
          _inputField(_descCtrl, 'Add Detailed Description', maxLines: 4),

          const SizedBox(height: 12),

          // ── Category & Price row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Category'),
                    const SizedBox(height: 6),
                    _dropdownField(
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (v) =>
                          setState(() => _selectedCategory = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Price'),
                    const SizedBox(height: 6),
                    _inputField(_priceCtrl, 'e.g. 5200',
                        prefix: 'R ', keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Locations ──
          _sectionLabel('Locations'),
          const SizedBox(height: 6),
          _inputField(_locationCtrl, 'e.g. Johannesburg, Gauteng'),

          const SizedBox(height: 12),

          // ── Condition ──
          _sectionLabel('Condition'),
          const SizedBox(height: 8),
          Row(
            children: _conditions.map((c) {
              final sel = _selectedCondition == c;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCondition = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? _C.primary.withOpacity(0.1)
                          : Colors.white,
                      border: Border.all(
                          color: sel ? _C.primary : _C.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      c,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: sel ? _C.primary : _C.grey),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // ── Serial Number ──
          _sectionLabel('Serial Number'),
          const SizedBox(height: 6),
          _inputField(_serialCtrl, 'Put Valid Serial for Verification'),

          const SizedBox(height: 12),

          // ── Link ──
          _sectionLabel('Link'),
          const SizedBox(height: 6),
          _inputField(_linkCtrl, 'Add Link'),

          const SizedBox(height: 20),

          // ── Submit ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _submit,
              child: const Text(
                'Submit Listing',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OFFER SERVICES FORM
// ─────────────────────────────────────────────
class _OfferServicesForm extends StatefulWidget {
  const _OfferServicesForm();

  @override
  State<_OfferServicesForm> createState() => _OfferServicesFormState();
}

class _OfferServicesFormState extends State<_OfferServicesForm> {
  final _nameCtrl  = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _priceCtrl = TextEditingController();
  String _selectedCategory = 'Academic';
  final Set<String> _selectedDays = {};

  static const _categories = [
    'Academic', 'Creative', 'Digital', 'Professional', 'Lifestyle',
  ];
  static const _days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in Name and Price'),
          backgroundColor: _C.primary,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service listing submitted! 🎉'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Service Name'),
          const SizedBox(height: 6),
          _inputField(_nameCtrl, 'e.g. Maths Tutoring Grade 12'),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Category'),
                    const SizedBox(height: 6),
                    _dropdownField(
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (v) =>
                          setState(() => _selectedCategory = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Price'),
                    const SizedBox(height: 6),
                    _inputField(_priceCtrl, 'e.g. R120/hr'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _sectionLabel('Description'),
          const SizedBox(height: 6),
          _inputField(_descCtrl, 'Describe your service and experience…',
              maxLines: 4),

          const SizedBox(height: 12),

          _sectionLabel('Availability'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _days.map((d) {
              final sel = _selectedDays.contains(d);
              return GestureDetector(
                onTap: () => setState(() {
                  sel ? _selectedDays.remove(d) : _selectedDays.add(d);
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? _C.primary : _C.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    d,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : _C.grey),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          _sectionLabel('Portfolio (optional)'),
          const SizedBox(height: 6),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: _C.lightGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.border),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_outlined, color: _C.grey, size: 32),
                  SizedBox(height: 6),
                  Text('Upload portfolio files',
                      style: TextStyle(color: _C.grey, fontSize: 13)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _submit,
              child: const Text(
                'Submit Service',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RIDE-BUDDY FORM
// ─────────────────────────────────────────────
class _RideBuddyForm extends StatefulWidget {
  const _RideBuddyForm();

  @override
  State<_RideBuddyForm> createState() => _RideBuddyFormState();
}

class _RideBuddyFormState extends State<_RideBuddyForm> {
  final _fromCtrl   = TextEditingController();
  final _toCtrl     = TextEditingController();
  final _seatsCtrl  = TextEditingController();
  final _priceCtrl  = TextEditingController();
  final _notesCtrl  = TextEditingController();
  DateTime? _departureDate;
  TimeOfDay? _departureTime;

  void _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (d != null) setState(() => _departureDate = d);
  }

  void _pickTime() async {
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (t != null) setState(() => _departureTime = t);
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _seatsCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('From'),
          const SizedBox(height: 6),
          _inputField(_fromCtrl, 'e.g. Soweto'),

          const SizedBox(height: 12),

          _sectionLabel('To'),
          const SizedBox(height: 6),
          _inputField(_toCtrl, 'e.g. Johannesburg CBD'),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Seats Available'),
                    const SizedBox(height: 6),
                    _inputField(_seatsCtrl, '1',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Price per Seat'),
                    const SizedBox(height: 6),
                    _inputField(_priceCtrl, 'R 0',
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Date'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickDate,
                      child: _dateTimeTile(
                        icon: Icons.calendar_today_outlined,
                        label: _departureDate == null
                            ? 'Select date'
                            : '${_departureDate!.day}/${_departureDate!.month}/${_departureDate!.year}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Time'),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickTime,
                      child: _dateTimeTile(
                        icon: Icons.access_time_rounded,
                        label: _departureTime == null
                            ? 'Select time'
                            : _departureTime!.format(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _sectionLabel('Notes'),
          const SizedBox(height: 6),
          _inputField(_notesCtrl,
              'Any pickup rules, stops, or extra info…', maxLines: 3),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ride-Buddy post submitted! 🛵'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text(
                'Post Ride',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _dateTimeTile({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _C.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: _C.grey, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: _C.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────
Widget _sectionLabel(String text) => Text(
      text,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: _C.dark),
    );

Widget _inputField(
  TextEditingController ctrl,
  String hint, {
  int maxLines = 1,
  String? prefix,
  TextInputType keyboardType = TextInputType.text,
}) =>
    TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: _C.dark),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefix,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.primary)),
        filled: true,
        fillColor: Colors.white,
      ),
    );

Widget _dropdownField({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) =>
    DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(fontSize: 13, color: _C.dark),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: onChanged,
    );