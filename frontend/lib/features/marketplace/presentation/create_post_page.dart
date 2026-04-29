import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _C {
  static const primary = Color(0xFFE53935);
  static const bg = Color(0xFFF6F6F6);
  static const border = Color(0xFFE0E0E0);
  static const text = Color(0xFF222222);
  static const hint = Color(0xFF9E9E9E);
}

// ─────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    _tab = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Create a post",
            style: TextStyle(color: _C.text, fontSize: 15)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: _C.text),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: _C.text,
                unselectedLabelColor: _C.hint,
                dividerColor: Colors.transparent,
                labelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: "Sell item"),
                  Tab(text: "Create a post"),
                  Tab(text: "Ridebuddy"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _SellUI(),
          _SellUI(),
          _SellUI(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// UI EXACT MATCH FORM
// ─────────────────────────────────────────────
class _SellUI extends StatefulWidget {
  const _SellUI();

  @override
  State<_SellUI> createState() => _SellUIState();
}

class _SellUIState extends State<_SellUI> {
  bool isLink = true;
  final picker = ImagePicker();
  final List<XFile> images = [];

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() => images.addAll(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Toggle buttons
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _toggleBtn("Create a post with link", isLink, () {
                  setState(() => isLink = true);
                }),
                _toggleBtn("Create a post manually", !isLink, () {
                  setState(() => isLink = false);
                }),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _field("Title", "Add title"),
          _field("Description", "Add Detailed Description", maxLines: 3),

          Row(
            children: [
              Expanded(child: _field("Category", "Electronics")),
              const SizedBox(width: 8),
              Expanded(child: _field("Price", "")),
            ],
          ),

          _field("Locations", "Current location"),

          // Upload image dropdown style
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label("Upload Image"),
              const SizedBox(height: 4),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: _box(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("browse in png or jpeg",
                        style: TextStyle(fontSize: 12, color: _C.hint)),
                    Icon(Icons.keyboard_arrow_down, size: 18)
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Image preview squares
          Row(
            children: List.generate(6, (i) {
              return GestureDetector(
                onTap: pickImages,
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.image, size: 14, color: _C.hint),
                ),
              );
            }),
          ),

          _field("Serial Number", "Put Valid Serial for Verification"),

          _field("More Options", ""),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {},
              child: const Text("Post now"),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── HELPERS ─────────

  Widget _toggleBtn(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: active ? _C.text : _C.hint,
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label(label),
          const SizedBox(height: 4),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(fontSize: 12, color: _C.hint),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: _C.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: _C.border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _C.border),
      );
}

// Label
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, color: _C.text),
    );
  }
}