import 'package:flutter/cupertino.dart';

import 'icon_card.dart';

class OnboardingIllustration extends StatelessWidget {
  final Color circleColor;
  final String centerSvg;
  final String topLeftSvg;
  final String bottomRightSvg;

  const OnboardingIllustration({
    super.key,
    required this.circleColor,
    required this.centerSvg,
    required this.topLeftSvg,
    required this.bottomRightSvg,
  });

  @override
  Widget build(BuildContext context) {
    // The whole illustration fits in a 240x240 bounding box.
    // Circle is 192x192 centered. Cards extend slightly outside.
    const double circleSize = 192;
    const double boxSize = 240;
    const double centerOffset = (boxSize - circleSize) / 2; // 24

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background circle — centered in box
          Positioned(
            left: centerOffset,
            top: centerOffset,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Center card (80x80, radius 16) — centered in box
          Positioned(
            left: (boxSize - 80) / 2,
            top: (boxSize - 80) / 2,
            child: IconCard(
              size: 80,
              borderRadius: 16,
              svgAsset: centerSvg,
              iconSize: 48,
            ),
          ),

          // Top-left card (56x56, radius 12)
          Positioned(
            left: 8,
            top: 8,
            child: IconCard(
              size: 56,
              borderRadius: 12,
              svgAsset: topLeftSvg,
              iconSize: 32,
            ),
          ),

          // Bottom-right card (56x56, radius 12)
          Positioned(
            right: 8,
            bottom: 8,
            child: IconCard(
              size: 56,
              borderRadius: 12,
              svgAsset: bottomRightSvg,
              iconSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
