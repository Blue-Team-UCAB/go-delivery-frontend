import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/auth/recover_password/recover_password_bloc.dart';
import '../login/inputDecorationLogin.dart';
import '../login/login_validators.dart';

class PasswordRenewScreen extends StatefulWidget {
  final String email;

  const PasswordRenewScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<PasswordRenewScreen> createState() => _PasswordRenewScreenState();
}

class _PasswordRenewScreenState extends State<PasswordRenewScreen> {
  List<String> code = ["", "", "", "", "", ""];
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _obscurePassword = false;
  String currentEmailHandler = '';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    context.read<RecoverPasswordBloc>().changeEmail(widget.email);
    currentEmailHandler = widget.email;
  }

  void _updateCode(String value) {
    setState(() {
      for (int i = 0; i < code.length; i++) {
        if (i < value.length) {
          code[i] = value[i];
        } else {
          code[i] = "";
        }
      }
    });

    if (value.length == 6) {
      context.read<RecoverPasswordBloc>().changeCode(value);
    }
  }

  bool _validateCode() {
    if (code.every((digit) => digit.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese el código de verificación'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (code.any((digit) => digit.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El código debe tener 6 dígitos'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02066F),
      body: BlocListener<RecoverPasswordBloc, RecoverPasswordState>(
        listenWhen: (previous, current) => previous.formStatus != current.formStatus,
        listener: (context, state) {
          switch (state.formStatus) {
            case RecoverPasswordFormStatus.validated:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contraseña cambiada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              break;
            case RecoverPasswordFormStatus.finished:
              context.go('/login');
              break;
            case RecoverPasswordFormStatus.invalid:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
              _codeController.clear();
              setState(() {
                code = ["", "", "", "", "", ""];
              });
              break;
            case RecoverPasswordFormStatus.resent:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Código reenviado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              break;
            default:
              break;
          }
        },
        child: SafeArea(
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
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Ingrese el Código enviado a: $currentEmailHandler y su contraseña nueva!',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            onChanged: (value) => context
                                .read<RecoverPasswordBloc>()
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
                                .buildInputDecorationLogin('Contraseña Nueva')
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
                          const SizedBox(height: 18),
                          BlocBuilder<RecoverPasswordBloc, RecoverPasswordState>(
                            buildWhen: (previous, current) =>
                            previous.formStatus != current.formStatus ||
                                previous.code != current.code,
                            builder: (context, state) {
                              final isLoading = state.formStatus ==
                                  RecoverPasswordFormStatus.posting ||
                                  state.formStatus ==
                                      RecoverPasswordFormStatus.validating;
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(6, (index) {
                                      return Container(
                                        width: 50,
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: code[index].isEmpty
                                                ? Colors.grey
                                                : isLoading
                                                ? Colors.blue
                                                : Colors.blue,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: isLoading &&
                                            index == code.indexOf("")
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Text(
                                          code[index],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  Opacity(
                                    opacity: 0,
                                    child: TextField(
                                      controller: _codeController,
                                      focusNode: _focusNode,
                                      maxLength: 6,
                                      keyboardType: TextInputType.text,
                                      onChanged: _updateCode,
                                      enabled: !isLoading,
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 45),
                          ElevatedButton(
                            onPressed: () {
                              if (!_validateCode()) {
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<RecoverPasswordBloc>()
                                    .submitPasswordChange();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF02066F),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cambiar Contraseña',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<RecoverPasswordBloc>()
                                  .sendCode(resend: true);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF02066F),
                            ),
                            child: const Text(
                              'Reenviar Código',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
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
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}