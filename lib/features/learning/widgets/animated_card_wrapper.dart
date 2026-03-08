import 'package:flutter/cupertino.dart';

class AnimatedCardWrapper extends StatelessWidget {
  final Widget child;
  final double scale;
  final double verticalOffset;
  final double opacity;
  final double horizontalOffset;

  const AnimatedCardWrapper({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.verticalOffset = 0,
    this.opacity = 1.0,
    this.horizontalOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(horizontalOffset, verticalOffset),
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: child,
        ),
      ),
    );
  }
}
