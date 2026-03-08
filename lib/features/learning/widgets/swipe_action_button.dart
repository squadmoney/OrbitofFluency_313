import 'package:flutter/cupertino.dart';

class SwipeActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double iconSize;
  final List<BoxShadow> shadows;
  final VoidCallback onPressed;

  const SwipeActionButton({
    super.key,
    required this.color,
    required this.icon,
    required this.iconSize,
    required this.shadows,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1),
          boxShadow: shadows,
        ),
        child: Center(
          child: Icon(icon, size: iconSize, color: const Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
