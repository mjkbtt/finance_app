import 'package:material_ui/material_ui.dart';

import '../../../data/models/finance_transaction.dart';
import '../../../shared/widgets/transaction_list_item.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Гүйлгээний Түүх',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Бүгдийг харах',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: homeTransactions.length,
              itemBuilder: (context, index) {
                return TransactionListItem(
                  transaction: homeTransactions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
