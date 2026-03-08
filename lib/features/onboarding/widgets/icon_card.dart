import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_shadows.dart';

class IconCard extends StatelessWidget {
  final double size;
  final double borderRadius;
  final String svgAsset;
  final double iconSize;

  const IconCard({
    super.key,
    required this.size,
    required this.borderRadius,
    required this.svgAsset,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: size >= 80 ? AppShadows.iconCard : AppShadows.smallIcon,
      ),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          width: iconSize,
          height: iconSize,
        ),
      ),
    );
  }
}
