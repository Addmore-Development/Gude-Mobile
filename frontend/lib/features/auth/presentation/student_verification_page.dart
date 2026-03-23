import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class StudentVerificationPage extends StatefulWidget {
  const StudentVerificationPage({super.key});
  @override
  State<StudentVerificationPage> createState() => _StudentVerificationPageState();
}

class _StudentVerificationPageState extends State<StudentVerificationPage> {
  bool _uploaded = false;
  String _selectedUniversity = '';
  final _studentNumber = TextEditingController();

  final _universities = ['UCT', 'Wits', 'UJ', 'UNISA', 'DUT', 'Stellenbosch', 'UP', 'NWU', 'Rhodes', 'UKZN'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => context.pop()),
        title: const Text('Verify Student Status', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Verifying your student status unlocks full marketplace access and wallet features.',
                      style: TextStyle(color: AppColors.textDark, fontSize: 13, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Select University', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedUniversity.isEmpty ? null : _selectedUniversity,
              hint: const Text('Choose your university'),
              decoration: InputDecoration(
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.inputBorder)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              items: _universities.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() => _selectedUniversity = v!),
            ),
            const SizedBox(height: 16),
            const Text('Student Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _studentNumber,
              decoration: const InputDecoration(hintText: 'Enter your student number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            const Text('Upload Student Card', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _uploaded = !_uploaded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 140,
                decoration: BoxDecoration(
                  color: _uploaded ? AppColors.primary.withOpacity(0.05) : const Color(0xFFF5F5F7),
                  border: Border.all(
                    color: _uploaded ? AppColors.primary : AppColors.inputBorder,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _uploaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 48),
                          const SizedBox(height: 8),
                          const Text('Student card uploaded', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          TextButton(onPressed: () => setState(() => _uploaded = false), child: const Text('Remove')),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file_outlined, color: AppColors.textGrey, size: 48),
                          SizedBox(height: 8),
                          Text('Tap to upload your student card', style: TextStyle(color: AppColors.textGrey)),
                          Text('JPG, PNG or PDF', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        ],
                      ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Verify & Continue', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Center(child: Text('Skip for now', style: TextStyle(color: AppColors.textGrey))),
            ),
          ],
        ),
      ),
    );
  }
}
