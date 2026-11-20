import 'package:material_ui/material_ui.dart';

import 'home_screen.dart';
import 'wallet_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const _PlaceholderScreen(title: 'Статистик'),
      WalletScreen(onBack: () => setState(() => _currentIndex = 0)),
      const _PlaceholderScreen(title: 'Профайл'),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_rounded, Icons.home_outlined, 0),
                _navItem(Icons.bar_chart_rounded, Icons.bar_chart_outlined, 1),
                _navItem(
                  Icons.account_balance_wallet_rounded,
                  Icons.account_balance_wallet_outlined,
                  2,
                ),
                _navItem(Icons.person_rounded, Icons.person_outline_rounded, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData activeIcon, IconData inactiveIcon, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Icon(
          isActive ? activeIcon : inactiveIcon,
          color: isActive ? const Color(0xFF438883) : Colors.grey[400],
          size: 30,
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
