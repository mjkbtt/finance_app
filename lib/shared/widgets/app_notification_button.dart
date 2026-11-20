import 'package:material_ui/material_ui.dart';

class AppNotificationButton extends StatelessWidget {
  const AppNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          Positioned(
            top: 9,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9B50),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
