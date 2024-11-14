import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  const AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.light : Brightness.light,
        colorSchemeSeed: const Color(0xFFFFFFFF),
        fontFamily: 'Inter, Montserrat',
        sliderTheme: SliderThemeData(
          inactiveTrackColor: Colors.transparent,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
          trackShape: const RectangularSliderTrackShape(),
          overlayShape: SliderComponentShape.noOverlay,
        )
      );

  AppTheme copyWith({bool? isDarkMode}) => AppTheme(
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
