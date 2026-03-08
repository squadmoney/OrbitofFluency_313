import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  // H1 Bold — word reveal, large titles
  static TextStyle h1Bold = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      color: AppColors.textPrimary,
    ),
  );

  // H2 SemiBold — section titles, onboarding titles
  static TextStyle h2SemiBold = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
  );

  // H3 Medium — screen titles, nav bar titles
  static TextStyle h3Medium = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      height: 1.3,
      color: AppColors.textPrimary,
    ),
  );

  // Button SemiBold — CTA buttons
  static TextStyle buttonSemiBold = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: CupertinoColors.white,
    ),
  );

  // Body Regular — body text, descriptions
  static TextStyle bodyRegular = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: AppColors.textSecondary,
    ),
  );

  // Body Bold — bold body text
  static TextStyle bodyBold = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: AppColors.textPrimary,
    ),
  );

  // Caption — 14px regular
  static TextStyle caption = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: AppColors.textSecondary,
    ),
  );

  // Caption Light — 14px light
  static TextStyle captionLight = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 14,
      fontWeight: FontWeight.w300,
      height: 1.4,
      color: AppColors.textSecondary,
    ),
  );

  // Small — 12px light (tab labels, category labels)
  static TextStyle small = GoogleFonts.anekBangla(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 12,
      fontWeight: FontWeight.w300,
      height: 1.33,
      color: AppColors.textSecondary,
    ),
  );

  // Input — Manrope Medium 16px (form fields)
  static TextStyle input = GoogleFonts.manrope(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: AppColors.textPrimary,
    ),
  );

  // Input placeholder
  static TextStyle inputPlaceholder = GoogleFonts.manrope(
    textStyle: const TextStyle(
      inherit: false,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: AppColors.textSecondary,
    ),
  );
}
