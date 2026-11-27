import 'package:material_ui/material_ui.dart';

import 'data/finance_store.dart';
import 'data/models/finance_transaction.dart';
import 'wallet_flow_widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static final List<String> _merchants = [
    'Netflix',
    'Spotify',
    'Youtube',
    'Paypal',
    'Electricity',
    'House Rent',
  ];

  String _merchant = '';
  String _amountDigits = '0';
  DateTime _date = DateTime.now();
  String? _paymentMethod;

  String? _merchantError;
  String? _amountError;
  String? _dateError;
  String? _paymentError;

  String get _amountText {
    final cents = int.tryParse(_amountDigits) ?? 0;
    return '\$ ${(cents / 100).toStringAsFixed(2)}';
  }

  String get _dateText {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[_date.weekday - 1]}, ${_date.day} '
        '${months[_date.month - 1]} ${_date.year}';
  }

  String? _validateMerchant() {
    if (_merchant.isEmpty) return 'Гүйлгээний нэрээ сонгоно уу';
    return null;
  }

  String? _validateAmount() {
    final cents = int.tryParse(_amountDigits) ?? 0;
    if (cents <= 0) return 'Үнийн дүнгээ оруулна уу (\$ 0.00-ээс их)';
    if (cents > 100000000) return 'Үнийн дүн хэтэрхий их байна';
    return null;
  }

  String? _validateDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(_date.year, _date.month, _date.day);
    if (selectedDay.isBefore(today)) {
      return 'Өнгөрсөн огноо сонгох боломжгүй';
    }
    return null;
  }

  String? _validatePayment() {
    if (_paymentMethod == null) return 'Төлбөрийн хэрэгслээ сонгоно уу';
    return null;
  }

  void _tapDigit(String digit) {
    setState(() {
      if (_amountDigits == '0') {
        _amountDigits = digit;
      } else if (_amountDigits.length < 9) {
        _amountDigits += digit;
      }
      if (_amountError != null) _amountError = _validateAmount();
    });
  }

  void _backspace() {
    setState(() {
      _amountDigits = _amountDigits.length <= 1
          ? '0'
          : _amountDigits.substring(0, _amountDigits.length - 1);
      _amountError = _validateAmount();
    });
  }

  Future<void> _pickMerchant() async {
    const addNewKey = '__add_new__';

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._merchants.map(
                (name) => ListTile(
                  leading: _MerchantLogo(name: name),
                  title: Text(name),
                  trailing: _merchant == name
                      ? const Icon(Icons.check, color: walletTeal)
                      : null,
                  onTap: () => Navigator.of(context).pop(name),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  radius: 17,
                  backgroundColor: walletTeal.withValues(alpha: 0.12),
                  child: const Icon(Icons.add, color: walletTeal),
                ),
                title: const Text(
                  'Шинэ нэр нэмэх',
                  style: TextStyle(
                    color: walletTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(addNewKey),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == addNewKey) {
      await _addCustomMerchant();
      return;
    }

    setState(() {
      if (selected != null) _merchant = selected;
      _merchantError = _validateMerchant();
    });
  }

  Future<void> _addCustomMerchant() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => const _AddMerchantDialog(),
    );

    if (newName != null && mounted) {
      setState(() {
        if (!_merchants.contains(newName)) {
          _merchants.add(newName);
        }
        _merchant = newName;
        _merchantError = _validateMerchant();
      });
    }
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected != null) {
      setState(() {
        _date = selected;
        _dateError = _validateDate();
      });
    }
  }

  Future<void> _pickPayment() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Wallet', 'Visa • 8075', 'Paypal']
              .map(
                (method) => ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: walletTeal,
                  ),
                  title: Text(method),
                  trailing: _paymentMethod == method
                      ? const Icon(Icons.check, color: walletTeal)
                      : null,
                  onTap: () => Navigator.of(context).pop(method),
                ),
              )
              .toList(),
        ),
      ),
    );

    setState(() {
      if (selected != null) _paymentMethod = selected;
      _paymentError = _validatePayment();
    });
  }

  void _saveExpense() {
    setState(() {
      _merchantError = _validateMerchant();
      _amountError = _validateAmount();
      _dateError = _validateDate();
      _paymentError = _validatePayment();
    });

    if (_merchantError != null ||
        _amountError != null ||
        _dateError != null ||
        _paymentError != null) {
      return;
    }

    final iconKey = _merchant.toLowerCase().contains('house')
        ? 'house'
        : _merchant.toLowerCase();

    FinanceStore.instance.addPending(
      FinanceTransaction(
        title: _merchant,
        subtitle: _dateText,
        amountText: '- $_amountText',
        isIncome: false,
        iconKey: iconKey,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_merchant ($_amountText) хүлээгдэж буй гүйлгээнд нэмэгдлээ!',
        ),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipPath(
                  clipper: _AddExpenseHeaderClipper(),
                  child: Container(
                    width: double.infinity,
                    height: 255,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF429690), walletDarkTeal],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -35,
                          top: -30,
                          child: Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  behavior: HitTestBehavior.opaque,
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Төлбөр нэмэх',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 112,
                  left: 20,
                  right: 20,
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('ГҮЙЛГЭЭНИЙ НЭР'),
                          const SizedBox(height: 8),
                          _MerchantSelector(
                            merchant: _merchant,
                            errorText: _merchantError,
                            onTap: _pickMerchant,
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('ҮНИЙН ДҮН'),
                          const SizedBox(height: 8),
                          _AmountField(
                            amount: _amountText,
                            errorText: _amountError,
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('ОГНОО'),
                          const SizedBox(height: 8),
                          _DateField(
                            date: _dateText,
                            errorText: _dateError,
                            onTap: _pickDate,
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('ТӨЛБӨР'),
                          const SizedBox(height: 8),
                          _DashedAddPayment(
                            label: _paymentMethod ?? 'Төлбөр нэмэх',
                            errorText: _paymentError,
                            onTap: _pickPayment,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _saveExpense,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: walletTeal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'ХАДГАЛАХ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _NumberKeyboard(onDigit: _tapDigit, onBackspace: _backspace),
        ],
      ),
    );
  }
}

class _AddExpenseHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 24);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 18,
      size.width,
      size.height - 24,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF666666),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  final String? text;
  const _FieldErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4),
      child: Text(
        text!,
        style: const TextStyle(color: Colors.redAccent, fontSize: 11),
      ),
    );
  }
}

class _MerchantSelector extends StatelessWidget {
  final String merchant;
  final String? errorText;
  final VoidCallback onTap;

  const _MerchantSelector({
    required this.merchant,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? Colors.redAccent : const Color(0xFFDCDCDC),
                width: hasError ? 1.4 : 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _MerchantLogo(name: merchant),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    merchant.isEmpty ? 'Гүйлгээний нэр сонгох' : merchant,
                    style: TextStyle(
                      color: merchant.isEmpty
                          ? const Color(0xFF999999)
                          : const Color(0xFF555555),
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8C8C8C)),
              ],
            ),
          ),
        ),
        _FieldErrorText(errorText),
      ],
    );
  }
}

class _MerchantLogo extends StatelessWidget {
  final String name;
  const _MerchantLogo({required this.name});

  @override
  Widget build(BuildContext context) {
    final (bgColor, child) = switch (name) {
      'Netflix' => (
        Colors.black,
        const Text(
          'N',
          style: TextStyle(
            color: Color(0xFFE50914),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      'Spotify' => (
        const Color(0xFF1DB954),
        const Icon(Icons.wifi_rounded, color: Colors.white, size: 20),
      ),
      'Youtube' => (
        const Color(0xFFFFEBEE),
        const Icon(
          Icons.smart_display_rounded,
          color: Color(0xFFE62117),
          size: 22,
        ),
      ),
      'Paypal' => (
        const Color(0xFF003087),
        const Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      'Electricity' => (
        const Color(0xFFFFF3E0),
        const Icon(Icons.bolt_rounded, color: Color(0xFFFF9800), size: 22),
      ),
      'House Rent' => (
        const Color(0xFFEAF3F2),
        const Icon(Icons.home_rounded, color: Color(0xFF3A7D76), size: 20),
      ),
      _ => (
        walletTeal.withValues(alpha: 0.14),
        name.isEmpty
            ? const Icon(
                Icons.receipt_long_rounded,
                color: walletTeal,
                size: 19,
              )
            : Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: walletTeal,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    };

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String amount;
  final String? errorText;

  const _AmountField({required this.amount, this.errorText});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.redAccent : walletTeal,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            amount,
            style: TextStyle(
              color: hasError ? Colors.redAccent : walletTeal,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _FieldErrorText(errorText),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String date;
  final String? errorText;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap, this.errorText});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? Colors.redAccent : const Color(0xFFDCDCDC),
                width: hasError ? 1.4 : 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: hasError ? Colors.redAccent : const Color(0xFF7E7E7E),
                  size: 19,
                ),
              ],
            ),
          ),
        ),
        _FieldErrorText(errorText),
      ],
    );
  }
}

class _DashedAddPayment extends StatelessWidget {
  final String label;
  final String? errorText;
  final VoidCallback onTap;

  const _DashedAddPayment({
    required this.label,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: hasError ? Colors.redAccent : const Color(0xFFD5D5D5),
            ),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle,
                    color: hasError
                        ? Colors.redAccent
                        : const Color(0xFF666666),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: hasError
                          ? Colors.redAccent
                          : const Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _FieldErrorText(errorText),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({this.color = const Color(0xFFD5D5D5)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const dash = 6.0;
    const gap = 5.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _NumberKeyboard extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const _NumberKeyboard({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD7DAE0),
      padding: const EdgeInsets.fromLTRB(6, 8, 6, 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _KeyCell(label: '1', onTap: () => onDigit('1')),
                _KeyCell(label: '2', letters: 'ABC', onTap: () => onDigit('2')),
                _KeyCell(label: '3', letters: 'DEF', onTap: () => onDigit('3')),
              ],
            ),
            Row(
              children: [
                _KeyCell(label: '4', letters: 'GHI', onTap: () => onDigit('4')),
                _KeyCell(label: '5', letters: 'JKL', onTap: () => onDigit('5')),
                _KeyCell(label: '6', letters: 'MNO', onTap: () => onDigit('6')),
              ],
            ),
            Row(
              children: [
                _KeyCell(
                  label: '7',
                  letters: 'PQRS',
                  onTap: () => onDigit('7'),
                ),
                _KeyCell(label: '8', letters: 'TUV', onTap: () => onDigit('8')),
                _KeyCell(
                  label: '9',
                  letters: 'WXYZ',
                  onTap: () => onDigit('9'),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: SizedBox(
                    height: 46,
                    child: Center(
                      child: Text('+*#', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                _KeyCell(label: '0', onTap: () => onDigit('0')),
                Expanded(
                  child: GestureDetector(
                    onTap: onBackspace,
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      height: 46,
                      child: Center(
                        child: Icon(Icons.backspace_outlined, size: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyCell extends StatelessWidget {
  final String label;
  final String? letters;
  final VoidCallback onTap;

  const _KeyCell({required this.label, required this.onTap, this.letters});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 46,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), offset: Offset(0, 1)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              if (letters != null)
                Text(
                  letters!,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMerchantDialog extends StatefulWidget {
  const _AddMerchantDialog();

  @override
  State<_AddMerchantDialog> createState() => _AddMerchantDialogState();
}

class _AddMerchantDialogState extends State<_AddMerchantDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Гүйлгээний нэрээ оруулна уу');
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Шинэ гүйлгээний нэр'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Ж.нь: Интернэт, СӨХ, Фитнесс',
          errorText: _error,
        ),
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Болих'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: walletTeal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Нэмэх'),
        ),
      ],
    );
  }
}
