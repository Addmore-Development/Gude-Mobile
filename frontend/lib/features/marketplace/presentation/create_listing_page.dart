import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});
  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  String _selectedCategory = 'Tutoring';
  final _categories = ['Tutoring', 'Design', 'Coding', 'Academic Help', 'Campus Services', 'Micro Internships'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => context.pop()),
        title: const Text('Create Listing', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _card(children: [
              _label('Service Title'),
              TextField(controller: _title, decoration: const InputDecoration(hintText: 'e.g. Maths Tutoring Grade 12')),
              const SizedBox(height: 16),
              _label('Category'),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.inputBorder)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              _label('Price (per hour)'),
              TextField(controller: _price, keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'e.g. 150', prefixText: 'R ')),
            ]),
            const SizedBox(height: 12),
            _card(children: [
              _label('Description'),
              TextField(controller: _description, maxLines: 4,
                decoration: const InputDecoration(hintText: 'Describe your service, experience, and what clients can expect...')),
            ]),
            const SizedBox(height: 12),
            _card(children: [
              _label('Availability'),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                  return FilterChip(
                    label: Text(day),
                    selected: false,
                    onSelected: (_) {},
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ]),
            const SizedBox(height: 12),
            _card(children: [
              _label('Portfolio (optional)'),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined, color: AppColors.textGrey, size: 32),
                        SizedBox(height: 8),
                        Text('Upload portfolio files', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () { context.pop(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Submit Listing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
    );
  }
}
