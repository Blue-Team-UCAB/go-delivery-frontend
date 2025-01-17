import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_state.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/presentation/screens/catalog/logout_from_catalog.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme_getter.dart';
import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

class SidebarScreen extends StatelessWidget {
  const SidebarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPrimaryThemeColor = AppThemesGetter.getPrimaryColor(context);

    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 0, 32),
        height: double.infinity,
        width: 288,
        color: currentPrimaryThemeColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CurrentUserBloc, CurrentUserState>(
              builder: (context, state) {
                if (state is CurrentUserLoaded) {
                  return ListTile(
                    title: Text(
                      _truncateText(state.name, 20),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    subtitle: Text(
                      _truncateText(state.email, 25),
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: state.image.isNotEmpty
                          ? NetworkImage(state.image)
                          : const AssetImage('assets/icon/user_150x150.png')
                              as ImageProvider,
                    ),
                  );
                } else if (state is CurrentUserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return ListTile(
                    title: const Text(
                      'Invitado',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    subtitle: const Text(
                      'guest@example.com',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/icon/user_150x150.png'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            // Opciones del sidebar
            ListTile(
              leading: const Icon(Icons.library_books, color: Colors.white),
              title: const Text(
                'Categorías',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              onTap: () {
                context.push('/category');
              },
            ),
              ListTile(
                leading: const Icon(Icons.track_changes, color: Colors.white),
                title: const Text(
                  'Rastrea tu orden',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                onTap: () {
                  context.push('/order');
                },
              ),
            if(!isPrimaryRed)
                ListTile(
                  leading:
                      const Icon(Icons.local_attraction_sharp, color: Colors.white),
                  title: const Text(
                    'Cupones',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  onTap: () {
                    context.push('/coupon');
                  },
                ),
            if(!isPrimaryRed)
                ListTile(
                  leading: const Icon(Icons.android_outlined, color: Colors.white),
                  title: const Text(
                    'Habla con Bluey',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  onTap: () {
                    context.push('/chatbot');
                  },
                ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFFFFFFF)),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              onTap: () {
                showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}...'
        : text;
  }
}
