import 'package:material_ui/material_ui.dart';

class BrandIcon extends StatelessWidget {
  final String iconKey;
  final double size;

  const BrandIcon({super.key, required this.iconKey, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final child = switch (iconKey) {
      'upwork' => const Text(
        'up',
        style: TextStyle(
          color: Color(0xFF6FDA44),
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: -1,
        ),
      ),
      'avatar' => const CircleAvatar(
        radius: 17,
        backgroundColor: Color(0xFFD5E3E2),
        child: Icon(Icons.person, color: Color(0xFF4A6664), size: 22),
      ),
      'paypal' => const Text(
        'P',
        style: TextStyle(
          color: Color(0xFF003087),
          fontWeight: FontWeight.w900,
          fontSize: 24,
          fontStyle: FontStyle.italic,
        ),
      ),
      'youtube' => const Icon(
        Icons.smart_display_rounded,
        color: Color(0xFFE62117),
        size: 30,
      ),
      'electricity' => const Icon(
        Icons.bolt_rounded,
        color: Color(0xFF3A7D76),
        size: 28,
      ),
      'house' => const Icon(
        Icons.home_rounded,
        color: Color(0xFF3A7D76),
        size: 28,
      ),
      'spotify' => const CircleAvatar(
        radius: 15,
        backgroundColor: Color(0xFF1DB954),
        child: Icon(Icons.wifi_rounded, color: Colors.white, size: 18),
      ),
      _ => const Icon(Icons.receipt_long, color: Colors.grey),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}
