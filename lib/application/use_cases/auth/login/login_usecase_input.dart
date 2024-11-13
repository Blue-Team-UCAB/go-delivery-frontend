import '../../../../common/result.dart';
import '../../../../common/use_cases.dart';
import '../../../../domain/repositories/user/user_repository.dart';

class LoginUseCaseInput extends IUseCaseInput {
  final String email;
  final String password;

  LoginUseCaseInput({
    required this.email,
    required this.password,
  });
}

class LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<bool>> execute(LoginUseCaseInput input) {
    return _userRepository.login(input.email, input.password);
  }
}