import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/user/user_mapper.dart';

import '../../../application/api/api_request.dart';
import '../../../application/key_value_storage/localstorage.dart';
import '../../../common/result.dart';
import '../../../domain/repositories/user/user_repository.dart';

enum UserType { CLIENT, ADMIN }

class UserRepositoryImpl implements UserRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  UserRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  @override
  Future<Result<bool>> login(String email, String password) async {
    try {
      final response = await _apiRequestManager.request<bool>(
        '/auth/login',
        'POST',
        (data) {
          if (data['error'] != null) {
            throw Exception(data['error']);
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
        body:
        {
          "email": email,
          "password": password
        },
      );
      return response;
    } catch (e) {
      print('Error in UserRepositoryImpl.login: $e');
      return Result.fail(Exception('Login failed') as Failure);
    }
  }

  @override
  Future<Result<bool>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _apiRequestManager.request<bool>(
        '/auth/register',
        'POST',
            (data) {
          return true;
        },
        body: {
          'email': email,
          'name': name,
          'password': password,
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      print('Error in UserRepositoryImpl.register: $e');
      return Result.fail(Exception('Registration failed') as Failure);
    }
  }

  @override
  Future<Result<bool>> sendRecoveryCode(String email) async {
    try {
      final response = await _apiRequestManager.request<bool>(
        '/send-recover_password-code',
        'POST',
            (data) => data['success'] as bool,
        body: {'email': email},
      );
      return response;
    } catch (e) {
      print('Error in UserRepositoryImpl.sendRecoveryCode: $e');
      return Result.fail(Exception('Failed to send recover_password code') as Failure);
    }
  }

  @override
  Future<Result<bool>> validateRecoveryCode(String email, String code) async {
    try {
      final response = await _apiRequestManager.request<bool>(
        '/validate-recover_password-code',
        'POST',
            (data) => data['valid'] as bool,
        body: {'email': email, 'code': code},
      );
      return response;
    } catch (e) {
      print('Error in UserRepositoryImpl.validateRecoveryCode: $e');
      return Result.fail(Exception('Failed to validate recover_password code') as Failure);
    }
  }

  @override
  Future<Result<bool>> changePassword(String email, String code, String password) async {
    try {
      final response = await _apiRequestManager.request<bool>(
        '/change-password',
        'POST',
            (data) => data['success'] as bool,
        body: {'email': email, 'code': code, 'password': password},
      );
      return response;
    } catch (e) {
      print('Error in UserRepositoryImpl.changePassword: $e');
      return Result.fail(Exception('Failed to change password') as Failure);
    }
  }
}