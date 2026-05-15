// lib/utils/responsive.dart
import 'package:flutter/material.dart';

class Responsive {
  final double width;
  final double height;

  Responsive(BuildContext context)
    : width = MediaQuery.of(context).size.width,
      height = MediaQuery.of(context).size.height;

  // Breakpoints
  bool get isMobileSmall => width < 360;
  bool get isMobileLarge => width >= 360 && width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
  bool get isDesktopLarge => width >= 1440;

  double get containerWidth {
    if (isMobileSmall) return width * 0.95;
    if (isMobileLarge) return width * 0.9;
    if (isTablet) return 600;
    if (isDesktop) return 1000;
    if (isDesktopLarge) return 1100;
    return width;
  }

  double get containerPadding {
    if (isMobileSmall) return 20;
    if (isMobileLarge) return 24;
    if (isTablet) return 32;
    if (isDesktop) return 40;
    return 48;
  }

  double get titleSize {
    if (isMobileSmall) return 24;
    if (isMobileLarge) return 26;
    if (isTablet) return 28;
    if (isDesktop) return 30;
    return 32;
  }

  double get bodySize {
    if (isMobileSmall) return 13;
    if (isMobileLarge) return 14;
    if (isTablet) return 15;
    return 16;
  }

  bool get showSideMenu => isDesktop;
  bool get isLandscape => width > height;

  int get gridCount {
    if (isMobileSmall) return 1;
    if (isMobileLarge) return 2;
    if (isTablet) return 3;
    if (isDesktop) return 4;
    return 5;
  }
}
