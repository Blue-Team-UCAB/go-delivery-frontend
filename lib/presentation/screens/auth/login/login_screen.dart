import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/login_validators.dart';
import 'package:go_router/go_router.dart';

import 'inputDecorationLogin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key,
    this.onLoginSuccess,
    }) : super(key: key);

  final void Function()? onLoginSuccess;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
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
                        controller: _emailController,
                        validator: (value) {
                          final result = loginValidator.emailValidator.validate(value);
                          return result.isSuccessful() ? null : result.getError().message;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontFamily: 'Montserrat'),
                        decoration: inputDecorationBuilderLogin.
                        buildInputDecorationLogin('Correo electrónico'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          final result = loginValidator.passwordValidator.validate(value);
                          return result.isSuccessful() ? null : result.getError().message;
                        },
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontFamily: 'Montserrat'),
                        decoration: inputDecorationBuilderLogin.
                        buildInputDecorationLogin('Contraseña').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            '¿Olvidaste la contraseña?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF02066F),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () { context.push('/'); },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02066F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No eres miembro?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          TextButton(
                            onPressed: () { context.push('/register'); },
                            child: const Text(
                              'Regístrate ahora',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF02066F),
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
                          for (final icon in ['google', 'apple', 'facebook']) ...[
                            if (icon != 'google') const SizedBox(width: 16),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: {
                                'google': const Color(0xFFEA4335),
                                'apple': Colors.black,
                                'facebook': const Color(0xFF1877F2),
                              }[icon],
                              child: SvgPicture.asset(
                                'assets/icon/$icon.svg',
                                color: Colors.white,
                                height: 24,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onLoginSuccessCallback() {
    //LocalStorageService().setKeyValue('', true);
    widget.onLoginSuccess?.call();
  }


}
