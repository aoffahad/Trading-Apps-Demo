import 'package:flutter/material.dart';

abstract final class Helpers {
  Helpers._();

  /// Returns padding that scales with screen size for consistent spacing across resolutions.
  static EdgeInsets responsivePadding(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final shortest = mq.shortestSide;
    final base = shortest < 600 ? 20.0 : 24.0;
    return EdgeInsets.symmetric(
      horizontal: mq.width * 0.05 + base * 0.5,
      vertical: base,
    );
  }

  /// Horizontal padding that adapts to screen width.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < 400) return 16;
    if (w < 600) return 20;
    return 24;
  }

  /// Use for layout that should adapt to orientation (e.g. different column/row).
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  
  static bool isCompact(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }
}
