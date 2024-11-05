import 'package:dio/dio.dart';

import '../../../domain/datasources/user/user_datasource.dart';
import '../../core/constants/environment.dart';
import '../../models/user/login_api.dart';

class APIUserDatasource extends UserDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.backendApi));

  @override
  Future<bool> register(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    await dio.post('/auth_old_template/register', data: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'type': 'CLIENT'
    });
    return true;
  }

  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await dio.post('/auth_old_template/login', data: {
      'email': email,
      'password': password,
    });
    final apiData = LoginAPIResponse.fromJson(response.data);
    return LoginResponse(type: apiData.type, token: apiData.token);
  }

  Future<bool> sendRecoveryCode(String email) async {
    await dio.post('/auth_old_template/forget/password', data: {
      'email': email,
    });
    return true;
  }

  Future<bool> changePassword(
      String email, String code, String password) async {
    await dio.put('/auth_old_template/change/password', data: {
      'email': email,
      'code': code,
      'password': password,
    });
    return true;
  }

  Future<bool> validateRecoveryCode(String email, String code) async {
    await dio.post('/auth_old_template/code/validate', data: {
      'email': email,
      'code': code,
    });
    return true;
  }
}
