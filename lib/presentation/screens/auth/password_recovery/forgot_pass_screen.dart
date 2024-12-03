import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/auth/recover_password/recover_password_bloc.dart';
import '../login/inputDecorationLogin.dart';
import '../login/login_validators.dart';

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
                            'Ingrese su correo electrónico registrado',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Le enviaremos un codigo de verificacion. Por favor revise su bandeja de entrada',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
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
                                      backgroundColor: const Color(0xFF02066F),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: state.formStatus ==
                                            RecoverPasswordFormStatus.posting
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Enviar código',
                                            style: TextStyle(
                                              color: Colors.white,
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
                                        child: const Text(
                                          'Volver a Iniciar Sesion',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF02066F),
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
