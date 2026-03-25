import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary     = Color(0xFFE30613);
  static const primaryDark = Color(0xFFB0000E);
  static const dark        = Color(0xFF1A1A1A);
  static const grey        = Color(0xFF888888);
  static const border      = Color(0xFFE8E8E8);
  static const inputBg     = Color(0xFFFAFAFA);
  static const green       = Color(0xFF10B981);
}

// ─────────────────────────────────────────────
// CARD TYPE DETECTION
// ─────────────────────────────────────────────
enum _CardType { unknown, visa, mastercard, amex, discover }

_CardType _detectCardType(String number) {
  final n = number.replaceAll(' ', '');
  if (n.startsWith('4')) return _CardType.visa;
  if (RegExp(r'^5[1-5]').hasMatch(n) ||
      RegExp(r'^2(2[2-9][1-9]|[3-6]\d{2}|7([01]\d|20))').hasMatch(n)) {
    return _CardType.mastercard;
  }
  if (RegExp(r'^3[47]').hasMatch(n)) return _CardType.amex;
  if (RegExp(r'^6(?:011|5)').hasMatch(n)) return _CardType.discover;
  return _CardType.unknown;
}

// ─────────────────────────────────────────────
// STUDENT VERIFICATION PAGE
// ─────────────────────────────────────────────
class StudentVerificationPage extends StatefulWidget {
  const StudentVerificationPage({super.key});
  @override
  State<StudentVerificationPage> createState() =>
      _StudentVerificationPageState();
}

class _StudentVerificationPageState extends State<StudentVerificationPage>
    with SingleTickerProviderStateMixin {
  // ── Step tracking ───────────────────────────
  int _step = 0; // 0 = ID, 1 = student card, 2 = bank card, 3 = done

  // ── ID step ─────────────────────────────────
  final _idCtrl = TextEditingController();

  // ── Student card step ────────────────────────
  final _studentNoCtrl = TextEditingController();
  String? _selectedInstitution;

  // ── Bank card step ───────────────────────────
  final _cardNumberCtrl  = TextEditingController();
  final _cardNameCtrl    = TextEditingController();
  final _cardExpiryCtrl  = TextEditingController();
  final _cardCvvCtrl     = TextEditingController();
  bool _cardFlipped = false;
  _CardType _cardType = _CardType.unknown;

  late AnimationController _flipCtrl;
  late Animation<double>   _flipAnim;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _flipAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));

    _cardNumberCtrl.addListener(() {
      final detected = _detectCardType(_cardNumberCtrl.text);
      if (detected != _cardType) setState(() => _cardType = detected);
    });
    _cardCvvCtrl.addListener(() {
      final hasFocus = _cardCvvCtrl.text.isNotEmpty;
      if (hasFocus && !_cardFlipped) {
        _flipCtrl.forward();
        setState(() => _cardFlipped = true);
      } else if (!hasFocus && _cardFlipped) {
        _flipCtrl.reverse();
        setState(() => _cardFlipped = false);
      }
    });
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    _idCtrl.dispose();
    _studentNoCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose();
    super.dispose();
  }

  // ── Formatted card number with spaces ────────
  String get _formattedNumber {
    final raw = _cardNumberCtrl.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < raw.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(raw[i]);
    }
    return buf.toString().padRight(19, '•'.padLeft(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: _C.dark, size: 18),
                onPressed: () => setState(() => _step--))
            : IconButton(
                icon: const Icon(Icons.close, color: _C.dark),
                onPressed: () => context.pop()),
        title: Text(
          _step == 0
              ? 'Identity Verification'
              : _step == 1
                  ? 'Student Verification'
                  : _step == 2
                      ? 'Link Bank Card'
                      : 'All Set!',
          style: const TextStyle(
              color: _C.dark, fontWeight: FontWeight.w800, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _step == 0
            ? _IdStep(key: const ValueKey(0), ctrl: _idCtrl, onNext: () => setState(() => _step = 1))
            : _step == 1
                ? _StudentStep(
                    key: const ValueKey(1),
                    studentNoCtrl: _studentNoCtrl,
                    selectedInstitution: _selectedInstitution,
                    onInstitutionChanged: (v) =>
                        setState(() => _selectedInstitution = v),
                    onNext: () => setState(() => _step = 2),
                  )
                : _step == 2
                    ? _BankCardStep(
                        key: const ValueKey(2),
                        cardNumberCtrl: _cardNumberCtrl,
                        cardNameCtrl: _cardNameCtrl,
                        cardExpiryCtrl: _cardExpiryCtrl,
                        cardCvvCtrl: _cardCvvCtrl,
                        cardType: _cardType,
                        flipAnim: _flipAnim,
                        formattedNumber: _formattedNumber,
                        onCvvFocus: (focused) {
                          if (focused && !_cardFlipped) {
                            _flipCtrl.forward();
                            setState(() => _cardFlipped = true);
                          } else if (!focused && _cardFlipped) {
                            _flipCtrl.reverse();
                            setState(() => _cardFlipped = false);
                          }
                        },
                        onNext: () => setState(() => _step = 3),
                      )
                    : _SuccessStep(
                        key: const ValueKey(3),
                        onDone: () => context.go('/home'),
                      ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STEP 1 — ID
// ─────────────────────────────────────────────
class _IdStep extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onNext;
  const _IdStep({super.key, required this.ctrl, required this.onNext});

  @override
  Widget build(BuildContext context) => _StepShell(
        emoji: '🪪',
        title: 'Verify your identity',
        subtitle: 'Enter your South African ID number',
        onNext: onNext,
        nextLabel: 'Continue',
        child: Column(children: [
          _label('SA ID Number'),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            maxLength: 13,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDeco(
                'e.g. 9001015009087', Icons.badge_outlined),
          ),
        ]),
      );
}

// ─────────────────────────────────────────────
// STEP 2 — Student card
// ─────────────────────────────────────────────
class _StudentStep extends StatelessWidget {
  final TextEditingController studentNoCtrl;
  final String? selectedInstitution;
  final ValueChanged<String?> onInstitutionChanged;
  final VoidCallback onNext;

  const _StudentStep({
    super.key,
    required this.studentNoCtrl,
    required this.selectedInstitution,
    required this.onInstitutionChanged,
    required this.onNext,
  });

  static const _institutions = [
    'UCT', 'Wits', 'Stellenbosch University', 'UKZN',
    'University of Pretoria', 'UJ', 'TUT', 'CPUT',
    'DUT', 'NMU', 'UWC', 'UFS', 'Rhodes', 'NWU', 'Other',
  ];

  @override
  Widget build(BuildContext context) => _StepShell(
        emoji: '🎓',
        title: 'Student verification',
        subtitle: 'Confirm your student status',
        onNext: onNext,
        nextLabel: 'Continue',
        child: Column(children: [
          _label('Institution'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: selectedInstitution,
            hint: const Text('Select your university / college',
                style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB))),
            items: _institutions
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
            onChanged: onInstitutionChanged,
            decoration: _inputDeco(null, Icons.school_outlined),
          ),
          const SizedBox(height: 14),
          _label('Student Number'),
          const SizedBox(height: 6),
          TextFormField(
            controller: studentNoCtrl,
            decoration: _inputDeco(
                'Enter your student number', Icons.numbers_outlined),
          ),
        ]),
      );
}

// ─────────────────────────────────────────────
// STEP 3 — Bank card with auto-detection
// ─────────────────────────────────────────────
class _BankCardStep extends StatelessWidget {
  final TextEditingController cardNumberCtrl, cardNameCtrl,
      cardExpiryCtrl, cardCvvCtrl;
  final _CardType cardType;
  final Animation<double> flipAnim;
  final String formattedNumber;
  final ValueChanged<bool> onCvvFocus;
  final VoidCallback onNext;

  const _BankCardStep({
    super.key,
    required this.cardNumberCtrl,
    required this.cardNameCtrl,
    required this.cardExpiryCtrl,
    required this.cardCvvCtrl,
    required this.cardType,
    required this.flipAnim,
    required this.formattedNumber,
    required this.onCvvFocus,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Animated card preview ─────────────────────────
        AnimatedBuilder(
          animation: flipAnim,
          builder: (_, __) {
            final isFront = flipAnim.value < 0.5;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(flipAnim.value * 3.14159),
              child: isFront
                  ? _CardFront(
                      cardType: cardType,
                      number: formattedNumber,
                      name: cardNameCtrl.text.isEmpty
                          ? 'YOUR NAME'
                          : cardNameCtrl.text.toUpperCase(),
                      expiry: cardExpiryCtrl.text.isEmpty
                          ? 'MM/YY'
                          : cardExpiryCtrl.text,
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(3.14159),
                      child: _CardBack(cvv: cardCvvCtrl.text),
                    ),
            );
          },
        ),

        const SizedBox(height: 24),

        // ── Card type badge ───────────────────────────────
        if (cardType != _CardType.unknown)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _C.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: _C.green.withOpacity(0.3)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle,
                  size: 14, color: _C.green),
              const SizedBox(width: 6),
              Text(
                '${_cardTypeName(cardType)} detected',
                style: const TextStyle(
                    fontSize: 12,
                    color: _C.green,
                    fontWeight: FontWeight.w600),
              ),
            ]),
          ),

        // ── Card number ───────────────────────────────────
        _label('Card Number'),
        const SizedBox(height: 6),
        TextFormField(
          controller: cardNumberCtrl,
          keyboardType: TextInputType.number,
          maxLength: 19,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          decoration: _inputDeco(
              '0000 0000 0000 0000', Icons.credit_card_outlined),
        ),
        const SizedBox(height: 14),

        _label('Name on Card'),
        const SizedBox(height: 6),
        TextFormField(
          controller: cardNameCtrl,
          textCapitalization: TextCapitalization.characters,
          decoration: _inputDeco('YOUR FULL NAME', Icons.person_outline),
        ),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Expiry Date'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: cardExpiryCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [_ExpiryFormatter()],
                    decoration: _inputDeco('MM/YY', Icons.calendar_today_outlined),
                  ),
                ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('CVV'),
                  const SizedBox(height: 6),
                  Focus(
                    onFocusChange: onCvvFocus,
                    child: TextFormField(
                      controller: cardCvvCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration:
                          _inputDeco('•••', Icons.lock_outline_rounded),
                    ),
                  ),
                ]),
          ),
        ]),

        const SizedBox(height: 24),

        SizedBox(
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
            onPressed: onNext,
            child: const Text('Link Card',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  String _cardTypeName(_CardType t) {
    switch (t) {
      case _CardType.visa:       return 'Visa';
      case _CardType.mastercard: return 'Mastercard';
      case _CardType.amex:       return 'Amex';
      case _CardType.discover:   return 'Discover';
      default:                   return '';
    }
  }
}

// ─────────────────────────────────────────────
// CARD FRONT
// ─────────────────────────────────────────────
class _CardFront extends StatelessWidget {
  final _CardType cardType;
  final String number, name, expiry;
  const _CardFront(
      {required this.cardType,
      required this.number,
      required this.name,
      required this.expiry});

  @override
  Widget build(BuildContext context) {
    final gradient = _cardGradient(cardType);
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: -30, right: -20,
          child: Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Gude logo
                Row(children: [
                  Image.asset(
                    'assets/images/gude_logo.webp',
                    width: 26,
                    height: 26,
                    errorBuilder: (_, __, ___) => Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Center(
                          child: Text('G',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14))),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('GUDE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1)),
                ]),
                _CardNetworkLogo(cardType: cardType),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 34, height: 24,
              decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(4)),
              child: CustomPaint(painter: _ChipPainter()),
            ),
            const Spacer(),
            Text(
              number,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.5),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('CARD HOLDER',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 9)),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('EXPIRES',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 9)),
                  Text(expiry,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ]),
        ),
      ]),
    );
  }

  LinearGradient _cardGradient(_CardType t) {
    switch (t) {
      case _CardType.visa:
        return const LinearGradient(
            colors: [Color(0xFF1A1F71), Color(0xFF2D4CC8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight);
      case _CardType.mastercard:
        return const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF3A3A3A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight);
      case _CardType.amex:
        return const LinearGradient(
            colors: [Color(0xFF006FCF), Color(0xFF00A8E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight);
      case _CardType.discover:
        return const LinearGradient(
            colors: [Color(0xFF231F20), Color(0xFFFF6600)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight);
      default:
        return const LinearGradient(
            colors: [Color(0xFFE30613), Color(0xFF8B000A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight);
    }
  }
}

// ─────────────────────────────────────────────
// CARD BACK
// ─────────────────────────────────────────────
class _CardBack extends StatelessWidget {
  final String cvv;
  const _CardBack({required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF333333), Color(0xFF1A1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 30),
        Container(height: 40, color: const Color(0xFF111111)), // Magnetic stripe
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(
              child: Container(
                height: 36,
                color: Colors.white,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  cvv.isEmpty ? '•••' : cvv,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: Color(0xFF1A1A1A)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('CVV',
                style:
                    TextStyle(color: Colors.white60, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// CARD NETWORK LOGO
// ─────────────────────────────────────────────
class _CardNetworkLogo extends StatelessWidget {
  final _CardType cardType;
  const _CardNetworkLogo({required this.cardType});

  @override
  Widget build(BuildContext context) {
    if (cardType == _CardType.mastercard) {
      return Stack(children: [
        Container(
            width: 26, height: 26,
            decoration: const BoxDecoration(
                color: Color(0xFFEB001B), shape: BoxShape.circle)),
        Positioned(
          left: 14,
          child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                  color: const Color(0xFFF79E1B).withOpacity(0.9),
                  shape: BoxShape.circle)),
        ),
      ]);
    }
    if (cardType == _CardType.visa) {
      return const Text('VISA',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: 1));
    }
    if (cardType == _CardType.amex) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4)),
        child: const Text('AMEX',
            style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      );
    }
    // Default — no logo / Gude card
    return Stack(children: [
      Container(
          width: 24, height: 24,
          decoration: const BoxDecoration(
              color: Color(0xFFEB001B), shape: BoxShape.circle)),
      Positioned(
        left: 12,
        child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.9),
                shape: BoxShape.circle)),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
// STEP 4 — Success
// ─────────────────────────────────────────────
class _SuccessStep extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessStep({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF0FFF4),
                      shape: BoxShape.circle),
                  child: const Center(
                      child: Text('🎉',
                          style: TextStyle(fontSize: 56))),
                ),
                const SizedBox(height: 24),
                const Text('Verified!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A))),
                const SizedBox(height: 12),
                const Text(
                  'Your identity, student status and bank card\nhave been successfully verified.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                      height: 1.5),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE30613),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: onDone,
                    child: const Text('Go to Home',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
        ),
      );
}

// ─────────────────────────────────────────────
// SHARED STEP SHELL
// ─────────────────────────────────────────────
class _StepShell extends StatelessWidget {
  final String emoji, title, subtitle, nextLabel;
  final Widget child;
  final VoidCallback onNext;

  const _StepShell({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
                color: const Color(0xFFE30613).withOpacity(0.1),
                shape: BoxShape.circle),
            child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 36))),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(subtitle,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF888888))),
        ),
        const SizedBox(height: 28),
        child,
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE30613),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shadowColor: const Color(0xFFE30613).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onNext,
            child: Text(nextLabel,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────
Widget _label(String t) => Text(t,
    style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF888888)));

InputDecoration _inputDeco(String? hint, IconData icon) => InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
      prefixIcon:
          Icon(icon, color: const Color(0xFFBBBBBB), size: 20),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      counterText: '',
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFFE30613), width: 1.5)),
    );

// Card number formatter: adds spaces every 4 digits
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) return oldValue;
    final buf = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(text[i]);
    }
    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Expiry formatter: adds / after 2 digits
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) return oldValue;
    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

// EMV chip painter
class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8964A)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(0, size.height * 0.3),
        Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}