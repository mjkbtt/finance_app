import 'package:material_ui/material_ui.dart';

class WalletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const WalletActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF438883), width: 1.2),
            ),
            child: Icon(icon, color: const Color(0xFF438883), size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF222222),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
