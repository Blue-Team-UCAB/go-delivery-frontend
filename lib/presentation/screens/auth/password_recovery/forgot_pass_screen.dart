import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:go_delivery_frontend/application/BLoc/auth/recover_password/recover_password_bloc.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/inputDecorationLogin.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/login/login_validators.dart';

import '../../../../application/BLoc/themes/themes_bloc.dart';
import '../../../core/theme/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themesBloc = context.watch<ThemesBloc>();
    final appTheme = themesBloc.state.appTheme;
    final isPrimaryRed = appTheme.colorMode == AppColorMode.red;
    final primaryColor = isPrimaryRed
        ? const Color(0xFF8F0000)
        : const Color(0xFF02066F);
    final secondaryColor = isPrimaryRed
        ? const Color(0xFFC60000)
        : const Color(0xFF2000B1);


    return BlocConsumer<RecoverPasswordBloc, RecoverPasswordState>(
      listener: (context, state) {
        if (state.formStatus == RecoverPasswordFormStatus.sent) {
          context.go('/password/renew', extra: state.email);
        }

        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: state.formStatus == RecoverPasswordFormStatus.posting
                  ? (isPrimaryRed ? Colors.red : primaryColor)
                  : primaryColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SvgPicture.asset(
                        state.formStatus == RecoverPasswordFormStatus.posting
                            ? (isPrimaryRed
                            ? 'assets/icon/logo_red.svg'
                            : 'assets/icon/logo.svg')
                            : (isPrimaryRed
                            ? 'assets/icon/logo_red.svg'
                            : 'assets/icon/logo.svg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: state.formStatus == RecoverPasswordFormStatus.posting
                              ? [
                            BoxShadow(
                              color: (isPrimaryRed ? Colors.red : primaryColor)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, -3),
                            )
                          ]
                              : null,
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Ingrese su correo electrónico registrado',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: state.formStatus == RecoverPasswordFormStatus.posting
                                      ? (isPrimaryRed ? Colors.red : primaryColor)
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Le enviaremos un codigo de verificacion. Por favor revise su bandeja de entrada',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: state.formStatus == RecoverPasswordFormStatus.posting
                                        ? (isPrimaryRed
                                        ? Colors.red.shade300
                                        : primaryColor.withOpacity(0.5))
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        validator: (value) {
                                          final result = loginValidator
                                              .emailValidator
                                              .validate(value);
                                          return result.isSuccessful()
                                              ? null
                                              : result.getError().message;
                                        },
                                        onChanged: (value) {
                                          context
                                              .read<RecoverPasswordBloc>()
                                              .changeEmail(value);
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat'),
                                        decoration: inputDecorationBuilderLogin
                                            .buildInputDecorationLogin(
                                            'Correo electrónico'),
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: state.formStatus ==
                                            RecoverPasswordFormStatus.posting
                                            ? null
                                            : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<RecoverPasswordBloc>()
                                                .sendCode();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: state.formStatus == RecoverPasswordFormStatus.posting
                                              ? (isPrimaryRed ? Colors.red : primaryColor)
                                              : primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Enviar código',
                                          style: TextStyle(
                                            color: state.formStatus == RecoverPasswordFormStatus.posting
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              context.push('/login');
                                            },
                                            child: Text(
                                              'Volver a Iniciar Sesion',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: state.formStatus == RecoverPasswordFormStatus.posting
                                                    ? (isPrimaryRed ? Colors.red : primaryColor)
                                                    : primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Overlay loading indicator
            if (state.formStatus == RecoverPasswordFormStatus.posting)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (isPrimaryRed ? Colors.red : primaryColor).withOpacity(0.6),
                        (isPrimaryRed ? Colors.blue : Colors.blue).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
