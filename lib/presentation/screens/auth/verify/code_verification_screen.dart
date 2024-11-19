import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/BLoc/auth/recover_password/recover_password_bloc.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({Key? key}) : super(key: key);

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  List<String> code = ["", "", "", "", "", ""];
  final _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
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
      context.read<RecoverPasswordBloc>().validateCode();
    }
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
              context.go('/password/create');
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
                flex: 1,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Ingrese el Código en su Correo Electrónico',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<RecoverPasswordBloc, RecoverPasswordState>(
                          buildWhen: (previous, current) =>
                          previous.formStatus != current.formStatus ||
                              previous.code != current.code,
                          builder: (context, state) {
                            final isLoading = state.formStatus == RecoverPasswordFormStatus.posting ||
                                state.formStatus == RecoverPasswordFormStatus.validating;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                                      child: isLoading && index == code.indexOf("")
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
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            context.read<RecoverPasswordBloc>().sendCode(resend: true);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF02066F),
                          ),
                          child: const Text(
                            'Reenviar Codigo',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
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
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}