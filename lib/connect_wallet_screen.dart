import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'wallet_flow_widgets.dart';

class ConnectWalletScreen extends StatefulWidget {
  final int initialTab;

  const ConnectWalletScreen({super.key, this.initialTab = 0});

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  late int _selectedTab;
  String _selectedMethod = 'Bank Link';

  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _cvcController = TextEditingController();
  final _expiryController = TextEditingController();
  final _valueController = TextEditingController();

  // Талбар тус бүрийн FocusNode (бичиж дуусаад гарах мөчийг мэдэрнэ)
  final _nameFocus = FocusNode();
  final _numberFocus = FocusNode();
  final _cvcFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _valueFocus = FocusNode();

  // Талбар тус бүрийн алдааны текст (null бол алдаагүй)
  String? _nameError;
  String? _numberError;
  String? _cvcError;
  String? _expiryError;
  String? _valueError;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab == 0 ? 0 : 1;

    _attachBlurCheck(_nameFocus, () => _nameError = _validateName());
    _attachBlurCheck(_numberFocus, () => _numberError = _validateNumber());
    _attachBlurCheck(_cvcFocus, () => _cvcError = _validateCvc());
    _attachBlurCheck(_expiryFocus, () => _expiryError = _validateExpiry());
    _attachBlurCheck(_valueFocus, () => _valueError = _validateValue());
  }

  // Талбараас focus гарах үед (бичиж дуусахад) автоматаар шалгана
  void _attachBlurCheck(FocusNode node, VoidCallback validate) {
    node.addListener(() {
      if (!node.hasFocus && mounted) {
        setState(validate);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _cvcController.dispose();
    _expiryController.dispose();
    _valueController.dispose();
    _nameFocus.dispose();
    _numberFocus.dispose();
    _cvcFocus.dispose();
    _expiryFocus.dispose();
    _valueFocus.dispose();
    super.dispose();
  }

  // --- Талбар тус бүрийн шалгах функцүүд ---
  String? _validateName() {
    final text = _nameController.text.trim();
    if (text.isEmpty) return 'Овог нэрээ оруулна уу';

    // Зөвхөн латин/кирилл үсэг болон хоосон зай зөвшөөрнө
    if (!RegExp(r'^[a-zA-ZА-Яа-яӨөҮүЁё\s-]+$').hasMatch(text)) {
      return 'Овог нэр зөвхөн үсгээс бүрдэх ёстой';
    }

    // Хоосон зайгаар салгаад дор хаяж 2 үг (овог, нэр) байгаа эсэхийг шалгана
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Овог болон нэрээ хоёуланг нь оруулна уу';
    }

    return null;
  }

  String? _validateNumber() {
    final digits = _numberController.text.replaceAll(RegExp(r'\s+'), '');
    if (digits.isEmpty) return 'Картын дугаараа оруулна уу';
    if (!RegExp(r'^\d+$').hasMatch(digits)) return 'Зөвхөн тоо оруулна уу';
    if (digits.length > 16) return '16 оронгоос илүү байж болохгүй';
    if (digits.length < 16) return 'Яг 16 оронтой байх ёстой';
    return null;
  }

  String? _validateCvc() {
    final cvc = _cvcController.text.trim();
    if (cvc.isEmpty) return 'CVC оруулна уу';
    if (!RegExp(r'^\d+$').hasMatch(cvc)) return 'Зөвхөн тоо оруулна уу';
    if (cvc.length > 3) return '3 оронгоос илүү байж болохгүй';
    if (cvc.length < 3) return 'Яг 3 оронтой байх ёстой';
    return null;
  }

  String? _validateExpiry() {
    final expiry = _expiryController.text.trim();
    if (expiry.isEmpty) return 'Хугацаа оруулна уу';

    final match = RegExp(r'^(\d{4})/(\d{2})$').firstMatch(expiry);
    if (match == null) return 'YYYY/MM (ж.нь: 2028/05)';

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    if (month < 1 || month > 12) return 'Сар 01–12 байх ёстой';

    final now = DateTime.now();
    final isExpired =
        year < now.year || (year == now.year && month < now.month);
    if (isExpired) return 'Картын хугацаа дууссан байна';

    return null;
  }

  String? _validateValue() {
    final text = _valueController.text.trim();
    if (text.isEmpty) return 'Дүнгээ оруулна уу';
    final value = double.tryParse(text);
    if (value == null || value <= 0) return 'Зөв дүн оруулна уу';
    return null;
  }

  void _continueAccount() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$_selectedMethod сонгогдлоо')));
  }

  void _submitCard() {
    // Keyboard хааж бүх талбарыг эцсийн байдлаар шалгана
    FocusScope.of(context).unfocus();
    setState(() {
      _nameError = _validateName();
      _numberError = _validateNumber();
      _cvcError = _validateCvc();
      _expiryError = _validateExpiry();
      _valueError = _validateValue();
    });

    if (_nameError != null ||
        _numberError != null ||
        _cvcError != null ||
        _expiryError != null ||
        _valueError != null) {
      return;
    }

    final value = double.parse(_valueController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Картаар \$ ${value.toStringAsFixed(2)} амжилттай цэнэглэгдлээ!',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Гаднах хоосон зай дээр дарахад keyboard хаагдаж тухайн талбарыг шалгана
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: walletDarkTeal,
        bottomNavigationBar: const WalletBottomNavBar(),
        body: Column(
          children: [
            WalletFlowHeader(
              title: _selectedTab == 0
                  ? 'Түрийвч цэнэглэх'
                  : 'Түрийвчтэй холбох',
            ),
            Expanded(
              child: WalletContentShell(
                scrollable: false,
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletSegmentedTabs(
                      selectedIndex: _selectedTab,
                      onChanged: (index) =>
                          setState(() => _selectedTab = index),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: KeyedSubtree(
                            key: ValueKey(_selectedTab),
                            child: _selectedTab == 0
                                ? _buildCardTab()
                                : _buildAccountTab(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryOutlineButton(
                      label: _selectedTab == 0 ? 'ИЛГЭЭХ' : 'ДАРААХ',
                      onPressed: _selectedTab == 0
                          ? _submitCard
                          : _continueAccount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _CreditCardPreview(
            name: _nameController.text,
            number: _numberController.text,
            expiry: _expiryController.text,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Картны мэдээлэлээ нэмэх',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Энд холбох карт нь зөвхөн таны нэр дээр\nбайх ёстой.',
          style: TextStyle(color: Color(0xFF737373), fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 18),
        _LabeledField(
          label: 'КАРТ ДЭЭРХ НЭР',
          hint: 'Нэр Овог',
          controller: _nameController,
          focusNode: _nameFocus,
          errorText: _nameError,
          onChanged: (_) => setState(() {
            // Алдаа гарсан байсан бол засмагц шууд арилгана
            if (_nameError != null) _nameError = _validateName();
          }),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _SmallField(
                label: 'КАРТЫН ДУГААР',
                controller: _numberController,
                focusNode: _numberFocus,
                keyboardType: TextInputType.number,
                errorText: _numberError,
                onChanged: (value) => setState(() {
                  final digits = value.replaceAll(RegExp(r'\s+'), '');
                  // 16-аас илүү бичсэн эсвэл өмнө нь алдаатай байсан бол шууд шалгана
                  if (_numberError != null || digits.length > 16) {
                    _numberError = _validateNumber();
                  }
                }),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SmallField(
                label: 'CVC',
                controller: _cvcController,
                focusNode: _cvcFocus,
                keyboardType: TextInputType.number,
                errorText: _cvcError,
                onChanged: (value) => setState(() {
                  if (_cvcError != null || value.trim().length > 3) {
                    _cvcError = _validateCvc();
                  }
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _SmallField(
                label: 'ДУУСАХ ХУГАЦАА  YYYY/MM',
                controller: _expiryController,
                focusNode: _expiryFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [_ExpiryDateFormatter()],
                errorText: _expiryError,
                onChanged: (value) => setState(() {
                  // 7 тэмдэгт (YYYY/MM) гүйцмэгц эсвэл засах үед шууд шалгана
                  if (_expiryError != null || value.length == 7) {
                    _expiryError = _validateExpiry();
                  }
                }),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _SmallField(
                label: 'Value \$',
                controller: _valueController,
                focusNode: _valueFocus,
                keyboardType: TextInputType.number,
                errorText: _valueError,
                onChanged: (_) => setState(() {
                  if (_valueError != null) _valueError = _validateValue();
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildAccountTab() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _ConnectOption(
          title: 'Bank Link',
          subtitle: 'Connect your bank\naccount to deposit & fund',
          icon: Icons.account_balance,
          selected: _selectedMethod == 'Bank Link',
          onTap: () => setState(() => _selectedMethod = 'Bank Link'),
        ),
        const SizedBox(height: 16),
        _ConnectOption(
          title: 'Microdeposits',
          subtitle: 'Connect bank in 5-7 days',
          icon: Icons.monetization_on,
          selected: _selectedMethod == 'Microdeposits',
          onTap: () => setState(() => _selectedMethod = 'Microdeposits'),
        ),
        const SizedBox(height: 16),
        _ConnectOption(
          title: 'Paypal',
          subtitle: 'Connect you paypal account',
          icon: Icons.paypal,
          selected: _selectedMethod == 'Paypal',
          onTap: () => setState(() => _selectedMethod = 'Paypal'),
        ),
      ],
    );
  }
}

class _CreditCardPreview extends StatelessWidget {
  final String name;
  final String number;
  final String expiry;

  const _CreditCardPreview({
    required this.name,
    required this.number,
    required this.expiry,
  });

  String get _displayName {
    final text = name.trim();
    return text.isEmpty ? 'IRVAN MOSES' : text.toUpperCase();
  }

  String get _displayNumber {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '6219   8610   2888   8075';
    }
    final padded = digits.padRight(16, '•').substring(0, 16);
    return '${padded.substring(0, 4)}   ${padded.substring(4, 8)}   '
        '${padded.substring(8, 12)}   ${padded.substring(12, 16)}';
  }

  String get _displayExpiry {
    final text = expiry.trim();
    return text.isEmpty ? '22/01' : text;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 232,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 276,
              height: 165,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F9D91), Color(0xFF64DFB9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Mono',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 32,
            child: Container(
              width: 316,
              height: 196,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2B7A74), Color(0xFF42A89F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2B7A74).withValues(alpha: 0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(22),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(painter: _CardArcPainter()),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      'Debit\nCard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: Text(
                      'Mono',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 46,
                    child: Container(
                      width: 30,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6DAD4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.sim_card_outlined,
                        size: 16,
                        color: Color(0xFF7D827B),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: Text(
                      _displayNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 4,
                    child: Text(
                      _displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 4,
                    child: Text(
                      _displayExpiry,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.12);
    final center = Offset(size.width * 0.50, size.height + 10);
    for (var radius = 26.0; radius < 152; radius += 17) {
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConnectOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _ConnectOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? walletTeal : const Color(0xFF8C8D8F);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 98,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF3F2) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFF2B7C76)
                          : walletMutedText,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: walletTeal, size: 26),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final borderColor = hasError ? Colors.redAccent : walletTeal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 54,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: borderColor, width: 1.6),
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: -9,
              left: 14,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: hasError
                        ? Colors.redAccent
                        : const Color(0xFF777777),
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 6),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _SmallField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _SmallField({
    required this.label,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.redAccent : const Color(0xFFDADADA),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.redAccent : walletTeal,
                  width: 1.3,
                ),
              ),
            ),
            style: const TextStyle(color: Color(0xFF333333), fontSize: 13),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 6 ? digits.substring(0, 6) : digits;

    final formatted = clipped.length > 4
        ? '${clipped.substring(0, 4)}/${clipped.substring(4)}'
        : clipped;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
