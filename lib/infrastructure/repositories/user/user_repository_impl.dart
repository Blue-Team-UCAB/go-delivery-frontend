import 'package:go_delivery_frontend/common/failure.dart';

import '../../../application/api/api_request.dart';
import '../../../application/key_value_storage/localstorage.dart';
import '../../../common/result.dart';
import '../../../domain/repositories/user/user_repository.dart';
import '../../mappers/user/user_mapper.dart';

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

    print(email);
    print(password);

    try {
      final response = await _apiRequestManager.request<bool>(
        '/auth/login',
        'POST',
            (data) {
          final client = ClientMapper.fromJson(data['user']);
          final token = data['token'] as String;
          final type = data['type'] == 'CLIENT' ? UserType.CLIENT : UserType.ADMIN;

          print(token);
          print("cliente: {$client}");
          print("tipo de cliente: {$type}");

          _localStorage.setKeyValue<String>('token', token);
          _localStorage.setKeyValue<bool>('isAdmin',true);

          return true;
        },
        body: {
          'email': email,
          'password': password,
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
          final id = ClientMapper.fromJson(data['id']);
          print("SUCCESS AQUI EL ID NUEVO: {$id}");

          return true;
        },
        body: {
          'email': email,
          'password': password,
          'name': name,
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