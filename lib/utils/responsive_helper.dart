import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return ScreenType.mobile;
    if (width < tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getScreenType(context) == ScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenType(context) == ScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenType(context) == ScreenType.desktop;

  static double fontSize(BuildContext context,
      {double mobile = 14, double tablet = 16, double desktop = 18}) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.desktop:
        return desktop;
    }
  }

  static EdgeInsets padding(BuildContext context) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return const EdgeInsets.all(12);
      case ScreenType.tablet:
        return const EdgeInsets.all(20);
      case ScreenType.desktop:
        return const EdgeInsets.all(32);
    }
  }

  static int gridCrossAxisCount(BuildContext context) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }
}
