import 'package:go_delivery_frontend/domain/repositories/notifications/notifications_repository.dart';

import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';

class SendDeviceTokenUseCaseInput extends IUseCaseInput {
  final String token;

  SendDeviceTokenUseCaseInput({required this.token});
}

class SendDeviceTokenUseCase {
  final NotificationsRepository _notificationsRepository;

  SendDeviceTokenUseCase(
      {required NotificationsRepository notificationsRepository})
      : _notificationsRepository = notificationsRepository;

  Future<Result<bool>> execute(SendDeviceTokenUseCaseInput input) {
    return _notificationsRepository.saveToken(input.token);
  }
}
