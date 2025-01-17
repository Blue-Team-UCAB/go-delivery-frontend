import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/use_cases/auth/recover_password/recovery_usecase_input.dart';

part 'recover_password_event.dart';
part 'recover_password_state.dart';

class RecoverPasswordBloc
    extends Bloc<RecoverPasswordEvent, RecoverPasswordState> {
  final RecoveryUseCase recoveryUseCase;

  RecoverPasswordBloc({required this.recoveryUseCase})
      : super(const RecoverPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<CodeChanged>(_onCodeChanged);
    on<ErrorOccurred>(_onErrorOcurred);
    on<RecoverPasswordCodeSent>(_onCodeSent);
    on<RecoverPasswordCodeResent>(_onCodeResent);
    on<RecoverPasswordCodeRequested>(_onCodeRequested);
    on<RecoverPasswordCodeValidated>(_onCodeValidated);
    on<RecoverPasswordCodeValidationRequested>(_onCodeValidationRequested);
    on<RecoverPasswordFormSubmitted>(_onFormSubmitted);
    on<RecoverPasswordCompleted>(_onRecoverCompleted);
  }

  void _onRecoverCompleted(
      RecoverPasswordCompleted event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(
      formStatus: RecoverPasswordFormStatus.finished,
      code: '',
      email: '',
      password: '',
    ));
  }

  void _onFormSubmitted(
      RecoverPasswordFormSubmitted event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(
      formStatus: RecoverPasswordFormStatus.posting,
    ));
  }

  void _onCodeSent(
      RecoverPasswordCodeSent event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(formStatus: RecoverPasswordFormStatus.sent));
  }

  void _onCodeResent(
      RecoverPasswordCodeResent event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(formStatus: RecoverPasswordFormStatus.resent));
  }

  void _onCodeRequested(
      RecoverPasswordCodeRequested event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(formStatus: RecoverPasswordFormStatus.posting));
  }

  void _onCodeValidated(
      RecoverPasswordCodeValidated event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(formStatus: RecoverPasswordFormStatus.validated));
  }

  void _onCodeValidationRequested(RecoverPasswordCodeValidationRequested event,
      Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(formStatus: RecoverPasswordFormStatus.posting));
  }

  void _onEmailChanged(EmailChanged event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
      PasswordChanged event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onCodeChanged(CodeChanged event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(code: event.code));
  }

  void _onErrorOcurred(
      ErrorOccurred event, Emitter<RecoverPasswordState> emit) {
    emit(state.copyWith(
        formStatus: RecoverPasswordFormStatus.invalid,
        errorMessage: event.errorMessage));
  }

  void changeEmail(String email) {
    add(EmailChanged(email: email));
  }

  void changePassword(String password) {
    add(PasswordChanged(password: password));
  }

  void changeCode(String code) {
    add(CodeChanged(code: code));
  }

  Future<void> sendCode({bool resend = false}) async {
    add(RecoverPasswordCodeRequested());
    if (state.email.isEmpty) {
      add(ErrorOccurred(errorMessage: 'You must enter your email'));
      return;
    }

    final input = SendRecoveryCodeInput(email: state.email);
    final sendRecoveryCodeResult = await recoveryUseCase.sendCode(input);

    if (sendRecoveryCodeResult.isSuccessful()) {
      add(resend ? RecoverPasswordCodeResent() : RecoverPasswordCodeSent());
    } else {
      add(ErrorOccurred(
          errorMessage: sendRecoveryCodeResult.getError().message));
    }
  }

  Future<void> validateCode() async {
    add(RecoverPasswordCodeValidationRequested());
    if (state.code == '') {
      add(ErrorOccurred(errorMessage: 'You must enter the code'));
      return;
    }

    if (state.code.length < 6) {
      add(ErrorOccurred(
          errorMessage:
          'You must enter all of the code\'s digits (entered code ${state.code})'));
      return;
    }

    final input = ValidateRecoveryCodeInput(
      email: state.email,
      code: state.code,
    );
    final codeValidationResult = await recoveryUseCase.validateCode(input);

    if (codeValidationResult.isSuccessful()) {
      add(RecoverPasswordCodeValidated());
    } else {
      add(ErrorOccurred(
          errorMessage: codeValidationResult.getError().message));
    }
  }

  Future<void> submitPasswordChange() async {
    add(RecoverPasswordFormSubmitted());
    if (state.password.isEmpty) {
      add(ErrorOccurred(errorMessage: 'You must enter a password'));
      return;
    }

    if (state.password.length < 8) {
      add(ErrorOccurred(errorMessage: 'Password must be at least 8 characters long'));
      return;
    }

    final input = ChangePasswordInput(
      email: state.email,
      code: state.code,
      password: state.password,
    );
    final passwordChangeResult = await recoveryUseCase.changePassword(input);

    if (passwordChangeResult.isSuccessful()) {
      add(RecoverPasswordCompleted());
    } else {
      add(ErrorOccurred(
          errorMessage: passwordChangeResult.getError().message));
    }
  }

}
