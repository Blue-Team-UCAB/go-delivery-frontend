import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/user/user_mapper.dart';

import '../../../application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import '../../../common/result.dart';
import '../../../domain/repositories/user/user_repository.dart';
import '../../models/user_model.dart';

enum UserType { CLIENT, ADMIN }

class UserRepositoryImpl implements UserRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  UserRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<bool>> login(String email, String password) async {
      var message;
      final response = await _apiRequestManager.request<bool>(
        '/auth/login',
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
        body: {"email": email, "password": password},
      );
      if(response.value == true) {
        return response;
      } else {
          return Result.fail(CustomFailure(message: message));
      }
  }

  @override
  Future<Result<bool>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    var message;
    final response = await _apiRequestManager.request<bool>(
        '/auth/register',
        'POST',
        (data) {
          if (data['errorCode'] != 200) {
            message = data["message"];
            return false;
          } else {
            return true;
          }
        },
        body: {
          'email': email,
          'name': name,
          'password': password,
          'phone': phone,
        },
      );

      if(response.value == true) {
        return response;
      } else {
        return Result.fail(CustomFailure(message: message));
      }
  }

  @override
  Future<Result<bool>> sendRecoveryCode(String email) async {
      var message;
      final response = await _apiRequestManager.request<bool>(
        '/auth/forgot/password',
        'POST',
            (data) {
              if (data['errorCode'] != 200) {
                message = data["message"];
                return false;
              } else
              return true;
            },
        body: {'email': email},
      );
      if(response.value == true) {
        return response;
      } else {
        return Result.fail(CustomFailure(message: message));
      }
  }

  @override
  Future<Result<bool>> validateRecoveryCode(String email, String code) async {
    var message;

    final response = await _apiRequestManager.request<bool>(
        '/auth/code/validate',
        'POST',
          (data) {
            print(data);
            return true;
          },
        body: {'email': email, 'code': code},
      );
    print(response.value);

    if(response.value == true) {
      return response;
    } else {
      return Result.fail(CustomFailure(message: message));
    }

  }

  @override
  Future<Result<bool>> changePassword(
      String email, String code, String password) async {
      print(email);
      print(code);
      print(password);

      final response = await _apiRequestManager.request<bool>(
        '/auth/change/password',
        'POST',
            (data) {
                return true;
          },
        body: {
          'email': email,
          'code': code,
          'password': password
        },
      );

      print(response.value);

      return response;
  }

  @override
  Future<Result<User>> getCurrent() async {
      await _addAuthorizationHeader();
      final response = await _apiRequestManager.request(
        '/auth/current',
        'GET',
            (data) {
                return UserMapper.fromJson(data);
            }
      );
      return response;
  }

}
