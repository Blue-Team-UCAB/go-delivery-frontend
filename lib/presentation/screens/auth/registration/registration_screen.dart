import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_delivery_frontend/presentation/core/common/validator.dart';
import 'package:go_delivery_frontend/presentation/screens/auth/registration/registration_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/auth/register/register_bloc.dart';
import '../../../../injector.dart';
import 'dialog_registration_window.dart';
import 'inputDecorationRegister.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => getIt<RegisterBloc>(), // Or your creation logic
      child: const RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState  extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _handleRegistration() async {

    if (_formKey.currentState!.validate()) {

      setState(() {
        _isLoading = true;
      });

      try {
        await context.read<RegisterBloc>().obSubmitRegister();

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al registrar: ${e.toString()}',
                style: const TextStyle(fontFamily: 'Montserrat'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
        listenWhen: (previous, current) =>
            previous.registerFormStatus != current.registerFormStatus,
        listener: (context, state) {
            if (state.registerFormStatus == RegisterFormStatus.invalid) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
              );
            }

            if (state.registerFormStatus == RegisterFormStatus.valid) {

              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return const AnimatedSuccessDialog();
                },
              );

            }

            if (state.registerFormStatus == RegisterFormStatus.valid) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Register success!')),
                );
            }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: const Color(0xFF02066F),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Registrate',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Rellena con tus datos y registrate!',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              onChanged: context.read<RegisterBloc>().fullnameChanged,
                              controller: _nameController,
                              validator: (value) {
                                final result = registrationValidator.usernameValidator.validate(value);
                                return result.isSuccessful() ? null : result.getError().message;
                              },
                              decoration: inputDecorationBuilderRegister.buildInputDecorationRegister
                                ('Nombre de Usuario Nuevo'),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              onChanged: context.read<RegisterBloc>().emailChanged,
                              controller: _emailController,
                              validator: (value) {
                                final result = registrationValidator.emailValidator.validate(value);
                                return result.isSuccessful() ? null : result.getError().message;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: inputDecorationBuilderRegister.buildInputDecorationRegister
                                (
                                  'Correo electrónico'),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              onChanged: context.read<RegisterBloc>().phoneChanged,
                              controller: _phoneController,
                              validator: (value) {
                                final result = registrationValidator.phoneValidator.validate(value);
                                return result.isSuccessful() ? null : result.getError().message;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: inputDecorationBuilderRegister.buildInputDecorationRegister
                                ('Número de teléfono'),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              onChanged: context.read<RegisterBloc>().passwordChanged,
                              controller: _passwordController,
                              validator: (value) {
                                final result = registrationValidator.passwordValidator.validate(value);
                                return result.isSuccessful() ? null : result.getError().message;
                              },
                              obscureText: _obscurePassword,
                              decoration: inputDecorationBuilderRegister.buildInputDecorationRegister
                                ('Contraseña')
                                  .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons
                                        .visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _confirmPasswordController,
                              validator: _validateConfirmPassword,
                              obscureText: _obscureConfirmPassword,
                              decoration: inputDecorationBuilderRegister.buildInputDecorationRegister
                                ('Confirmar contraseña').copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () =>
                                      setState(() =>
                                      _obscureConfirmPassword =
                                      !_obscureConfirmPassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: state.registerFormStatus == RegisterFormStatus.posting
                                ? null
                                : _handleRegistration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF02066F),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: Colors.grey,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Text(
                                'Registrarse',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿Ya tienes una cuenta?',
                                  style: TextStyle(fontFamily: 'Montserrat'),
                                ),
                                TextButton(
                                  onPressed: () { context.push('/login'); },
                                  child: const Text(
                                    'Iniciar sesión',
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
                  ),
                ),
              ],
            ),
          )
        )
      );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


}