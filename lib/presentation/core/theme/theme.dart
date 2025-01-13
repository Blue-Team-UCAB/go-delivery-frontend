import 'package:flutter/material.dart';

enum AppColorMode {
  red,
  blue
}

class AppTheme {
  final AppColorMode colorMode;

  const AppTheme({this.colorMode = AppColorMode.blue});

  ThemeData getTheme() {
    switch (colorMode) {
      case AppColorMode.red:
        return _buildTheme(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF8F0000),  // Dark Crimson
          secondaryColor: const Color(0xFFC60000),  // Bright Red
        );
      case AppColorMode.blue:
        return _buildTheme(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF02066F),
          secondaryColor: const Color(0xFF2000B1),
        );
    }
  }

  ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ),
      fontFamily: 'Inter, Montserrat',
      sliderTheme: SliderThemeData(
        inactiveTrackColor: Colors.transparent,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
        trackShape: const RectangularSliderTrackShape(),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
    );
  }

  AppTheme copyWith({AppColorMode? colorMode}) => AppTheme(
    colorMode: colorMode ?? this.colorMode,
  );
}
