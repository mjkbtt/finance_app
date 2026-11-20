import 'package:material_ui/material_ui.dart';

class WalletTransactionTabs extends StatelessWidget {
  final TabController controller;

  const WalletTransactionTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: const Color(0xFF444444),
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Гүйлгээнүүд'),
          Tab(text: 'Хүлээгдэж буй гүйлгээ'),
        ],
      ),
    );
  }
}
