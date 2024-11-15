import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_delivery_frontend/application/BLoc/themes/themes_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/login_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/auth/login/login_bloc.dart';
import '../../../../injector.dart';
import 'inputDecorationLogin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      // BlocProvider in LoginScreen
      create: (context) => getIt<LoginBloc>(), // Or your creation logic
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
  // Corrected line
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
    bool isDarkMode = context.watch<ThemesBloc>().isDarkMode;

    return BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        listener: (context, state) {
          if (state.formStatus == LoginFormStatus.valid) {
            context.go('/');
          } else if (state.formStatus == LoginFormStatus.invalid &&
              state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  duration: const Duration(milliseconds: 1000),
                  content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF02066F),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: SvgPicture.asset(
                      'assets/icon/logo.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Bienvenido',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  onChanged: (value) => context
                                      .read<LoginBloc>()
                                      .changeEmail(value),
                                  controller: _emailController,
                                  validator: (value) {
                                    final result = loginValidator.emailValidator
                                        .validate(value);
                                    return result.isSuccessful()
                                        ? null
                                        : result.getError().message;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style:
                                      const TextStyle(fontFamily: 'Montserrat'),
                                  decoration: inputDecorationBuilderLogin
                                      .buildInputDecorationLogin(
                                          'Correo electrónico'),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  onChanged: (value) => context
                                      .read<LoginBloc>()
                                      .changePassword(value),
                                  controller: _passwordController,
                                  validator: (value) {
                                    final result = loginValidator
                                        .passwordValidator
                                        .validate(value);
                                    return result.isSuccessful()
                                        ? null
                                        : result.getError().message;
                                  },
                                  obscureText: _obscurePassword,
                                  style:
                                      const TextStyle(fontFamily: 'Montserrat'),
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push('/password/reset');
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF02066F),
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
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return ElevatedButton(
                                      onPressed: state.formStatus ==
                                              LoginFormStatus.posting
                                          ? null
                                          : _pressSubmit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF02066F),
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
                                    TextButton(
                                      onPressed: () {
                                        context.push('/register');
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF02066F),
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
                                  ],
                                ),
                                const Text(
                                  'O continúa con',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (final icon in [
                                      'google',
                                      'apple',
                                      'facebook'
                                    ]) ...[
                                      if (icon != 'google')
                                        const SizedBox(width: 16),
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: {
                                          'google': const Color(0xFFEA4335),
                                          'apple': Colors.black,
                                          'facebook': const Color(0xFF1877F2),
                                        }[icon],
                                        child: SvgPicture.asset(
                                          'assets/icon/$icon.svg',
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
