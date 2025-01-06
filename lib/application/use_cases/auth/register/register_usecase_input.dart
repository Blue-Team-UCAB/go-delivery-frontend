import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/user/user_repository.dart';

class RegisterUseCaseInput extends IUseCaseInput {
  final String email;
  final String password;
  final String name;
  final String phone;

  RegisterUseCaseInput({
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
  });
}

class RegisterUseCase {
  final UserRepository _userRepository;

  RegisterUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<bool>> execute(RegisterUseCaseInput input) {
    return _userRepository.register(
        email: input.email,
        password: input.password,
        name: input.name,
        phone: input.phone
    );
  }
}