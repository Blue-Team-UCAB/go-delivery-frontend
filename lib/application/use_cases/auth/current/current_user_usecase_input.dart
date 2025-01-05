import 'package:go_delivery_frontend/infrastructure/models/user_model.dart';

import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/repositories/user/user_repository.dart';

class CurrentUserUseCase {
  final UserRepository _userRepository;

  CurrentUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<User>> execute() {
    return _userRepository.getCurrent();
  }
}