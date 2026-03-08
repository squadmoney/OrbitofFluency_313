import 'package:flutter/cupertino.dart';

abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFFFF8F0); // warm off-white (main app bg)
  static const Color backgroundBlue = Color(0xFFF0F9FF); // light sky blue (onboarding, learning)
  static const Color card = Color(0xFFFFFFFF); // white cards
  static const Color inputBg = Color(0xFFF7F9FA); // input field bg, icon picker circles

  // Accent
  static const Color accent = Color(0xFF4F6AF5); // primary accent (buttons, active tab)
  static const Color accentLight = Color(0x334F6AF5); // accent at 20% opacity
  static const Color accentShadow = Color(0xFFAAC5FE); // plus button shadow

  // Text
  static const Color textPrimary = Color(0xFF111827); // headlines, nav titles
  static const Color textSecondary = Color(0xFF6B7280); // body, inactive labels

  // Semantic
  static const Color error = Color(0xFFEF4444); // swipe-left, error
  static const Color success = Color(0xFF22C55E); // swipe-right, success
  static const Color warning = Color(0xFFF59E0B); // warning
  static const Color info = Color(0xFF3B82F6); // info

  // Borders
  static const Color border = Color(0xFF111827); // input border default
  static const Color borderFocused = Color(0xFF4A8DFF); // input border focused
  static const Color divider = Color(0xFFF0F0F0); // row dividers

  // Onboarding / Collection colors
  static const Color orange = Color(0xFFFF8C42);
  static const Color teal = Color(0xFF4ECDC4);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color mint = Color(0xFFA8E6CF);
  static const Color peach = Color(0xFFFFD3B6);
  static const Color pink = Color(0xFFFFAAA5);
  static const Color lightGreen = Color(0xFFDCEDC1);
  static const Color mauve = Color(0xFFD4A5A5);

  // Misc
  static const Color warmTint = Color(0xFFF0E6D8); // neutral warm (dashed border)
  static const Color badgeBg = Color(0xFFFFF8F0); // badge/icon container bg
  static const Color imageOverlay = Color(0x99000000); // 60% black overlay
  static const Color greenGlow = Color(0xFFD0FBCC); // success button glow shadow

  // Collection colors as list for picker
  static const List<Color> collectionColors = [
    orange,
    teal,
    coral,
    mint,
    peach,
    pink,
    lightGreen,
    mauve,
  ];
}
