import '../../../../common/result.dart';
import '../../../../common/use_cases.dart';
import '../../../../domain/repositories/user/user_repository.dart';

class SendRecoveryCodeInput extends IUseCaseInput {
  final String email;

  SendRecoveryCodeInput({required this.email});
}

class ValidateRecoveryCodeInput extends IUseCaseInput {
  final String email;
  final String code;

  ValidateRecoveryCodeInput({
    required this.email,
    required this.code,
  });
}

class ChangePasswordInput extends IUseCaseInput {
  final String email;
  final String code;
  final String password;

  ChangePasswordInput({
    required this.email,
    required this.code,
    required this.password,
  });
}

class RecoveryUseCase {
  final UserRepository _userRepository;

  RecoveryUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<bool>> sendCode(SendRecoveryCodeInput input) {
    return _userRepository.sendRecoveryCode(input.email);
  }

  Future<Result<bool>> validateCode(ValidateRecoveryCodeInput input) {
    return _userRepository.validateRecoveryCode(input.email, input.code);
  }

  Future<Result<bool>> changePassword(ChangePasswordInput input) {
    return _userRepository.changePassword(
      input.email,
      input.code,
      input.password,
    );
  }
}