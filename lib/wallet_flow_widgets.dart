import 'package:material_ui/material_ui.dart';

import 'shared/widgets/app_notification_button.dart';

const walletTeal = Color(0xFF3A9E94);
const walletDarkTeal = Color(0xFF2A7C76);
const walletDarkText = Color(0xFF2B2B2B);
const walletMutedText = Color(0xFF8A8A8A);

/// 1) Дээд номин толгой (Буцах < + Гарчиг + Хонх эсвэл ... дүрс)
class WalletFlowHeader extends StatelessWidget {
  final String title;
  final bool showNotification;
  final bool showMore;

  const WalletFlowHeader({
    super.key,
    required this.title,
    this.showNotification = true,
    this.showMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
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
            left: -40,
            top: -30,
            child: _HeaderRing(size: 190, opacity: 0.08),
          ),
          Positioned(
            left: 55,
            top: -20,
            child: _HeaderRing(size: 115, opacity: 0.07),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: showMore
                        ? const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 28,
                          )
                        : showNotification
                        ? const AppNotificationButton()
                        : const SizedBox.shrink(),
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

/// 2) Дээд 2 булан нь дугуйрсан цагаан дэвсгэр карт
class WalletContentShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool scrollable;

  const WalletContentShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(28, 28, 28, 12),
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}

/// 3) "Картууд" | "Аккаунт" гулсдаг 2 таб
class WalletSegmentedTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const WalletSegmentedTabs({
    super.key,
    required this.selectedIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(children: [_tab('Картууд', 0), _tab('Аккаунт', 1)]),
        ],
      ),
    );
  }

  Widget _tab(String text, int index) {
    final selected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: selected ? null : () => onChanged?.call(index),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF444444)
                  : const Color(0xFF777777),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// 4) Connect Wallet доод навигацийн мөр (Түрийвч идэвхтэй)
class WalletBottomNavBar extends StatelessWidget {
  const WalletBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(
                  Icons.home_outlined,
                  color: Colors.grey[400],
                  size: 30,
                ),
              ),
              Icon(Icons.bar_chart_outlined, color: Colors.grey[400], size: 30),
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFF438883),
                size: 30,
              ),
              Icon(
                Icons.person_outline_rounded,
                color: Colors.grey[400],
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 5) Номин хүрээтэй цагаан товч ("ИЛГЭЭХ", "ДАРААХ")
class PrimaryOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryOutlineButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: walletTeal,
          side: const BorderSide(color: walletTeal, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: opacity),
          width: 14,
        ),
      ),
    );
  }
}
