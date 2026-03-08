import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      offset: Offset(0, 2),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> learningCard = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 8),
      blurRadius: 30,
    ),
  ];

  static const List<BoxShadow> dropdown = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.1)
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> plusButton = [
    BoxShadow(
      color: AppColors.accentShadow,
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> greenGlow = [
    BoxShadow(
      color: Color(0xFFD0FBCC),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0xFFD0FBCC),
      offset: Offset(0, 10),
      blurRadius: 15,
    ),
  ];

  static const List<BoxShadow> iconCard = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 20),
      blurRadius: 25,
    ),
  ];

  static const List<BoxShadow> smallIcon = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
    ),
  ];
}
