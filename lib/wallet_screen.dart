import 'package:material_ui/material_ui.dart';

import 'add_expense_screen.dart';
import 'connect_wallet_screen.dart';
import 'features/wallet/widgets/wallet_action_button.dart';
import 'features/wallet/widgets/wallet_balance_summary.dart';
import 'features/wallet/widgets/wallet_header.dart';
import 'features/wallet/widgets/wallet_transaction_lists.dart';
import 'features/wallet/widgets/wallet_transaction_tabs.dart';

class WalletScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const WalletScreen({super.key, this.onBack});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showInfo(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A7C76),
      body: Column(
        children: [
          WalletHeader(onBack: widget.onBack),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  const WalletBalanceSummary(),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WalletActionButton(
                        icon: Icons.add,
                        label: 'Нэмэх',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ConnectWalletScreen(initialTab: 0),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 56),
                      WalletActionButton(
                        icon: Icons.qr_code_2_rounded,
                        label: 'Төлбөр',
                        onTap: () async {
                          final added = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => const AddExpenseScreen(),
                            ),
                          );
                          if (added == true) {
                            _tabController.animateTo(1);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  WalletTransactionTabs(controller: _tabController),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        WalletTransactionList(),
                        WalletPendingList(),
                      ],
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
