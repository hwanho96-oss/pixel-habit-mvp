import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Web-only phone-sized frame. Native apps pass [child] through unchanged.
class MobileFrame extends StatelessWidget {
  const MobileFrame({super.key, required this.child});

  static const double frameWidth = 393;
  static const double frameHeight = 852;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(frameWidth, constraints.maxWidth);
        final height = math.min(frameHeight, constraints.maxHeight);
        final size = Size(width, height);

        return ColoredBox(
          color: Colors.grey.shade300,
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(size: size),
                child: ClipRect(child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}
