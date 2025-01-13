import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

import '../../../application/BLoc/themes/themes_bloc.dart';

class AppThemesGetter {
  static Color getPrimaryColor(BuildContext context) {
    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;

    return isPrimaryRed
        ? const Color(0xFF8F0000)
        : const Color(0xFF02066F);
  }

  static Color getSecondaryColor(BuildContext context) {
    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;

    return isPrimaryRed
        ? const Color(0xFFC60000)
        : const Color(0xFF2000B1);
  }
}