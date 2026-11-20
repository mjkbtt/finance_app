import 'package:material_ui/material_ui.dart';

class WalletBalanceSummary extends StatelessWidget {
  const WalletBalanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Нийт үлдэгдэл',
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        const Text(
          '\$ 2,548.00',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}
