import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_delivery_frontend/application/BLoc/notifications/bloc/notifications_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/login_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:go_delivery_frontend/application/BLoc/auth/login/login_bloc.dart';
import 'package:go_delivery_frontend/injector.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/inputDecorationLogin.dart';

import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/infrastructure/datasources/localstorage/localstorage_impl.dart';
import 'package:go_delivery_frontend/presentation/core/theme/theme.dart';

import 'package:go_delivery_frontend/application/BLoc/cart/cart_bloc.dart';
import 'package:go_delivery_frontend/presentation/core/app.dart';

import '../../../core/theme/theme_getter.dart';
import '../../../widgets/dialog_darken_window.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => getIt<LoginBloc>(),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.onLoginSuccess});

  final void Function()? onLoginSuccess;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    context.read<LoginBloc>().changeEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    context.read<LoginBloc>().changePassword(_passwordController.text);
  }

  void _pressSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorMode currentColorMode =
        context.watch<ThemesBloc>().currentColorMode;

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        if (state.formStatus == LoginFormStatus.valid) {
          context.read<NotificationsBloc>().sendFCMToken();
          context.go('/');
        } else if (state.formStatus == LoginFormStatus.invalid &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          color: currentColorMode == AppColorMode.blue
              ? const Color(0xFF02066F)
              : const Color(0xFF8F0000),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  // Theme switcher
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PopupMenuButton<AppColorMode>(
                          offset: const Offset(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Datasource',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.dataset,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (BuildContext context) {
                            final currentColorMode =
                                context.read<ThemesBloc>().currentColorMode;

                            return [
                              PopupMenuItem<AppColorMode>(
                                value: AppColorMode.blue,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Azul',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: currentColorMode ==
                                                AppColorMode.blue
                                            ? Color(0xFF02066F)
                                            : Colors.black,
                                        fontWeight: currentColorMode ==
                                                AppColorMode.blue
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    if (currentColorMode == AppColorMode.blue)
                                      Icon(Icons.check,
                                          color: Color(0xFF02066F)),
                                  ],
                                ),
                              ),
                              PopupMenuItem<AppColorMode>(
                                value: AppColorMode.red,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rojo',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color:
                                            currentColorMode == AppColorMode.red
                                                ? Color(0xFF8F0000)
                                                : Colors.black,
                                        fontWeight:
                                            currentColorMode == AppColorMode.red
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    if (currentColorMode == AppColorMode.red)
                                      Icon(Icons.check,
                                          color: Color(0xFF8F0000)),
                                  ],
                                ),
                              ),
                            ];
                          },
                          onSelected: (AppColorMode? newMode) async {
                            if (newMode != null &&
                                newMode != context.read<ThemesBloc>().state.appTheme.colorMode) {
                              context.read<ThemesBloc>().changeTheme();

                              context.read<CartBloc>().emptyCart();

                              final localStorageService = LocalStorageService();

                              String apiUrl;
                              if (newMode == AppColorMode.blue) {
                                apiUrl = dotenv.env['API_URL']!;
                              } else if (newMode == AppColorMode.red) {
                                apiUrl = dotenv.env['RED_API_URL']!;
                              } else {
                                apiUrl = dotenv.env['API_URL']!;
                              }

                              await localStorageService.setKeyValue<String>(
                                  "CURRENT_API_URL", apiUrl);
                              await localStorageService.setKeyValue<String>(
                                  'colorMode', newMode.toString());

                              Future.delayed(const Duration(seconds: 2), () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AnimatedSuccessDialog(
                                      title: 'Hay que Reiniciar la app!',
                                      message: 'para aplicar cambios!',
                                      buttonText: 'Okey',
                                      icon: Icons.warning,
                                      iconColor: Colors.grey,
                                      buttonColor: Colors.grey,
                                      onButtonPressed: () {
                                        context.pop();
                                      },
                                    );
                                  },
                                );
                              });

                              Future.delayed(const Duration(seconds: 4), () {
                                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              });

                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // Animated Logo
                  Expanded(
                    flex: 3,
                    child: FadeIn(
                      duration: const Duration(milliseconds: 500),
                      key: ValueKey(currentColorMode),
                      child: SlideInUp(
                        duration: const Duration(milliseconds: 500),
                        child: SvgPicture.asset(
                          currentColorMode == AppColorMode.blue
                              ? 'assets/icon/logo.svg'
                              : 'assets/icon/logo_red.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Animated Form Container
                  Expanded(
                    flex: 4,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: currentColorMode == AppColorMode.blue
                                  ? const Color(0xFF02066F).withOpacity(0.3)
                                  : const Color(0xFF8F0000).withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Animated Welcome Text
                                FadeInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: const Text(
                                    'Bienvenido',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),
                                FadeInLeft(
                                  duration: const Duration(milliseconds: 500),
                                  child: TextFormField(
                                    onChanged: (value) => context
                                        .read<LoginBloc>()
                                        .changeEmail(value),
                                    controller: _emailController,
                                    validator: (value) {
                                      final result = LoginValidator
                                          .emailValidator
                                          .validate(value);
                                      return result.isSuccessful()
                                          ? null
                                          : result.getError().message;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat'),
                                    decoration: inputDecorationBuilderLogin
                                        .buildInputDecorationLogin(
                                            'Correo electrónico'),
                                  ),
                                ),

                                const SizedBox(height: 16),
                                FadeInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: TextFormField(
                                    onChanged: (value) => context
                                        .read<LoginBloc>()
                                        .changePassword(value),
                                    controller: _passwordController,
                                    validator: (value) {
                                      final result = LoginValidator
                                          .passwordValidator
                                          .validate(value);
                                      return result.isSuccessful()
                                          ? null
                                          : result.getError().message;
                                    },
                                    obscureText: _obscurePassword,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat'),
                                    decoration: inputDecorationBuilderLogin
                                        .buildInputDecorationLogin('Contraseña')
                                        .copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () => setState(() =>
                                                _obscurePassword =
                                                    !_obscurePassword),
                                          ),
                                        ),
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElasticIn(
                                    duration: const Duration(milliseconds: 500),
                                    child: TextButton(
                                      onPressed: () {
                                        context.push('/password/forgot');
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: currentColorMode ==
                                                AppColorMode.blue
                                            ? const Color(0xFF02066F)
                                            : const Color(0xFF8F0000),
                                      ),
                                      child: const Text(
                                        '¿Olvidaste la contraseña?',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return ZoomIn(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: ElevatedButton(
                                        onPressed: state.formStatus ==
                                                LoginFormStatus.posting
                                            ? null
                                            : _pressSubmit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: currentColorMode ==
                                                  AppColorMode.blue
                                              ? const Color(0xFF02066F)
                                              : const Color(0xFF8F0000),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: state.formStatus ==
                                                LoginFormStatus.posting
                                            ? const CircularProgressIndicator(
                                                color: Colors.white)
                                            : const Text(
                                                'Iniciar sesión',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿No eres miembro?',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                      ),
                                    ),
                                    FadeIn(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: TextButton(
                                        onPressed: () {
                                          context.push('/register');
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: currentColorMode ==
                                                  AppColorMode.blue
                                              ? const Color(0xFF02066F)
                                              : const Color(0xFF8F0000),
                                        ),
                                        child: const Text(
                                          'Regístrate ahora',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
