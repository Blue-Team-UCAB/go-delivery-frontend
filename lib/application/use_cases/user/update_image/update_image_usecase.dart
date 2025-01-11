import 'dart:io';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/user/user_repository.dart';

class UpdateUserImageUseCaseInput extends IUseCaseInput {
  final File image;

  UpdateUserImageUseCaseInput({required this.image});
}

class UpdateUserImageUseCase {
  final UserRepository _userRepository;

  UpdateUserImageUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<bool>> execute(UpdateUserImageUseCaseInput input) {
    return _userRepository.updateUserImage(input.image);
  }
}
