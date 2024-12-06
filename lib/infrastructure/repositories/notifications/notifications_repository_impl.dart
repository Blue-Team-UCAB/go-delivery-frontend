import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/entities/notifications/notification.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/notifications/notifications_repository.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/product_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/user/user_mapper.dart';

import '../../../application/api/api_request.dart';

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
      '/user/tokenDevice',
      'POST',
      (data) {
        if (data['errorCode'] != 200) {
          message = data["message"];

          return false;
        } else {
          final userData = data['value'] as Map<String, dynamic>;
          var user = UserMapper.fromJson(userData);

          _apiRequestManager.setHeaders(
              'Authorization', 'Bearer ${user.token}');

          _localStorage.setKeyValue<bool>('isAdmin', true);
          _localStorage.setKeyValue<String>('appToken', user.token);
        }
        return true;
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


/* Esto se va a cambiar porque Datasource es repo en nuestro repo y repo es la llamada

class NotificationRespositoryImpl implements NotificationsRepository {
  final NotificationsDatasource notificationsDatasource;
  NotificationRespositoryImpl({required this.notificationsDatasource});
  @override
  Future<Result<bool>> deleteAll() async {
    try {
      await notificationsDatasource.deleteAll();
      return Result.success(true);
    } catch (error, _) {
      return Result<bool>.fail(error as Failure);
    }
  }

  @override
  Future<Result<int>> getNotRead() async {
    try {
      final count = await notificationsDatasource.getNotRead();
      return Result<int>.success(count);
    } catch (error, _) {
      return Result.fail(error as Failure);
    }
  }

  @override
  Future<Result<Notification>> getNotificationById(String id) async {
    try {
      final notification =
          await notificationsDatasource.getNotificationById(id);
      return Result<Notification>.success(notification);
    } catch (error, _) {
      return Result.fail(error as Failure);
    }
  }

  @override
  Future<Result<List<Notification>>> getNotificationsPaginated(
      {int page = 1, int perPage = 10}) async {
    try {
      final notifications = await notificationsDatasource
          .getNotificationsPaginated(page: page, perPage: perPage);
      return Result<List<Notification>>.success(notifications);
    } catch (error, _) {
      return Result<List<Notification>>.fail(error as Failure);
    }
  }

  @override
  Future<Result<bool>> markRead(String id) async {
    try {
      await notificationsDatasource.markRead(id);
      return Result.success(true);
    } catch (error, _) {
      return Result<bool>.fail(error as Failure);
    }
  }

  @override
  Future<Result<bool>> saveToken(String token) async {
    try {
      await notificationsDatasource.saveToken(token);
      return Result.success(true);
    } catch (error, _) {
      return Result.fail(error as Exception);
    }
  }
}

*/
