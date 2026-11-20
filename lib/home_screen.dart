import 'package:material_ui/material_ui.dart';

import 'features/home/widgets/balance_card.dart';
import 'features/home/widgets/home_header.dart';
import 'features/home/widgets/transaction_history_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HomeHeader(),
          Positioned(top: 155, left: 20, right: 20, child: BalanceCard()),
          Padding(
            padding: EdgeInsets.only(top: 375),
            child: TransactionHistorySection(),
          ),
        ],
      ),
    );
  }
}
