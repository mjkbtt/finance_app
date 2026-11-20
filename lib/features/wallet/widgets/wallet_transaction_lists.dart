import 'package:material_ui/material_ui.dart';

import '../../../data/models/finance_transaction.dart';
import '../../../shared/widgets/transaction_list_item.dart';

class WalletTransactionList extends StatelessWidget {
  const WalletTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      itemCount: walletTransactions.length,
      itemBuilder: (context, index) {
        return TransactionListItem(transaction: walletTransactions[index]);
      },
    );
  }
}

class WalletPendingList extends StatelessWidget {
  const WalletPendingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      itemCount: pendingTransactions.length,
      itemBuilder: (context, index) {
        final item = pendingTransactions[index];
        return TransactionListItem(
          transaction: item,
          trailing: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.title} төлбөр төлөх дарлаа')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFECF9F8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Төлөх',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF438883),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
