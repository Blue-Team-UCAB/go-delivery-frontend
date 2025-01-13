import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/user/user_mapper.dart';
import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/repositories/user/user_repository.dart';
import 'package:go_delivery_frontend/infrastructure/models/user_model.dart';

enum UserType { CLIENT, ADMIN }

class AuthRepositoryImpl implements UserRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  AuthRepositoryImpl({
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
    final response = await _apiRequestManager.request<bool>(
      '/api/auth/login',
      'POST',
      (data) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            return false;
          } else {
            var user = UserMapper.fromJson(data);
            _apiRequestManager.setHeaders(
                'Authorization', 'Bearer ${user.token}');
            _localStorage.setKeyValue<bool>('isAdmin', true);
            _localStorage.setKeyValue<String>('appToken', user.token);
            return true;
          }
        }
        return false;
      },
      body: {"email": email, "password": password},
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(CustomFailure(message: 'Login Fallido!: ${response.error?.message.toString()}'));
      }
    } else {
      return Result.fail(CustomFailure(message: 'Login Fallido!: ${response.error?.message.toString()}'));
    }
  }

  @override
  Future<Result<bool>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final response = await _apiRequestManager.request<bool>(
      '/api/auth/register',
      'POST',
      (data) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            return false;
          } else {
            return true;
          }
        }
        return false;
      },
      body: {
        'email': email,
        'name': name,
        'password': password,
        'phone': phone,
      },
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(CustomFailure(message: 'Registro Fallido!'));
      }
    } else {
      return Result.fail(CustomFailure(message: 'Registro Fallido!'));
    }
  }

  @override
  Future<Result<bool>> sendRecoveryCode(String email) async {

    print("el body:${email}");

    final response = await _apiRequestManager.request<bool>(
      '/api/auth/forget/password',
      'POST',
      (data) {
        return true;
      },
      body: {'email': email},
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(CustomFailure(message: "Hubo un problema enviando el codigo con su Email"));
      }
    } else {
      return Result.fail(CustomFailure(message: "Hubo un problema enviando el codigo con su Email"));
    }
  }

  @override
  Future<Result<bool>> validateRecoveryCode(String email, String code) async {

    final response = await _apiRequestManager.request<bool>(
      '/api/auth/code/validate',
      'POST',
      (data) {
        print(data);
        return true;
      },
      body: {'email': email, 'code': code},
    );

    if (response.isSuccess) {
        return Result.success(true);
    } else {
      return Result.fail(CustomFailure(message: "Algo Salio mal con la validacion del codigo"));
    }
  }

  @override
  Future<Result<bool>> changePassword(
      String email, String code, String password) async {
    final response = await _apiRequestManager.request<bool>(
      '/api/auth/change/password',
      'PUT',
      (data) {
        return true;
      },
      body: {'email': email, 'code': code, 'password': password},
    );

    return response;
  }

  @override
  Future<Result<User>> getCurrent() async {
    await _addAuthorizationHeader();
    final response =
        await _apiRequestManager.request('/api/auth/current', 'GET', (data) {
      return UserMapper.fromJson(data);
    });

    return response;
  }

  @override
  Future<Result<bool>> updateUserImage(File image) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<Map<String, dynamic>>(
      '/api/user/update/image',
      'PATCH',
      (data) {
        if (data is Map<String, dynamic> && data.containsKey('image')) {
          return data;
        }
        throw Exception('Respuesta inesperada');
      },
      body: FormData.fromMap({
        'image': MultipartFile.fromFileSync(image.path),
      }),
    );
    if (response.isSuccess) {
      return Result.success(true);
    } else {
      return Result.fail(
          CustomFailure(message: 'Error al actualizar la imagen'));
    }
  }
}
