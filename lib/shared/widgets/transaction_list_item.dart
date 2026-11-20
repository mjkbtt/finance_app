import 'package:material_ui/material_ui.dart';

import '../../data/models/finance_transaction.dart';
import 'brand_icon.dart';

class TransactionListItem extends StatelessWidget {
  final FinanceTransaction transaction;
  final Widget? trailing;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          BrandIcon(iconKey: transaction.iconKey),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          trailing ??
              Text(
                transaction.amountText,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: transaction.isIncome
                      ? const Color(0xFF25A969)
                      : const Color(0xFFF95B51),
                ),
              ),
        ],
      ),
    );
  }
}
