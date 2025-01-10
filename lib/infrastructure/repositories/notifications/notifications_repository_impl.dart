import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/entities/notifications/notification.dart';
import 'package:go_delivery_frontend/domain/repositories/notifications/notifications_repository.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  NotificationsRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  @override
  Future<Result<bool>> saveToken(String token) async {
    var message;

    final response = await _apiRequestManager.request<bool>(
      '/api/Notifications/savetoken',
      'POST',
      (data) {
        if (data['errorCode'] != 200) {
          message = data["message"];
          return false;
        } else {
          return true;
        }
      },
      body: {"token": token},
    );
    if (response.value == true) {
      return response;
    } else {
      return Result.fail(CustomFailure(message: message));
    }
  }

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<bool>> deleteAll() async {
    await _addAuthorizationHeader();
// TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<Result<int>> getNotRead() async {
    await _addAuthorizationHeader();
    // TODO: implement getNotRead
    throw UnimplementedError();
  }

  @override
  Future<Result<Notification>> getNotificationById(String id) async {
    await _addAuthorizationHeader();
    // TODO: implement getNotificationById
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Notification>>> getNotificationsPaginated(
      {int? page, int? perPage}) {
    // TODO: implement getNotificationsPaginated
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> markRead(String id) {
    // TODO: implement markRead
    throw UnimplementedError();
  }
}

