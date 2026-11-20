import 'package:material_ui/material_ui.dart';

class AuthCurvedHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double height;

  const AuthCurvedHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomCurveClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        color: const Color(0xFF2E837B),
        child: Stack(
          children: [
            // Зүүн дээд 2 цайвар цэнхэр тойрог
            Positioned(
              top: -15,
              left: -75,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF9DF0FF).withValues(alpha: 0.85),
                ),
              ),
            ),
            Positioned(
              top: -80,
              left: -10,
              child: Container(
                width: 205,
                height: 205,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF47C5DF).withValues(alpha: 0.7),
                ),
              ),
            ),
            // Гарчиг ба дэд гарчиг
            Align(
              alignment: const Alignment(0, 0.35),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 34);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 22,
      size.width,
      size.height - 34,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
