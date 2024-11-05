import 'package:dio/dio.dart';

import '../../../application/key_value_storage/key_value_storage.dart';
import '../../../domain/datasources/clients/clients_datasource.dart';
import '../../../domain/entities/client/client.dart';
import '../../core/constants/environment.dart';
import '../../models/client/client_api.dart';

class ClientsDatasourceImpl extends ClientsDatasource {
  final KeyValueStorageService keyValueStorage;
  final dio = Dio(BaseOptions(baseUrl: Environment.backendApi));

  ClientsDatasourceImpl(this.keyValueStorage) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await keyValueStorage.getValue<String>('token');
      options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    }));
  }

  @override
  Future<Client> getClientData() async {
    final response = await dio.get('/auth_old_template/current');
    final apiClient = ClientAPI.fromJson(response.data);
    return Client(
        email: apiClient.email,
        name: apiClient.name,
        id: apiClient.id,
        phone: apiClient.phone,
        avatarImage: apiClient.avatarImage);
  }

  @override
  Future<bool> update(
      {String? email,
      String? name,
      String? phone,
      String? avatarImage,
      String? password}) async {
    final body = <String, String>{};
    if (email != null) body['email'] = email;
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (avatarImage != null) body['image'] = avatarImage; //Cambiar
    if (password != null) body['password'] = password;
    await dio.put(
      '/user/update',
      data: body,
    );
    return true;
  }

  @override
  Future<bool> checkDeviceLink(String deviceToken) async {
    await dio.get('/user/is/device/linked?token=$deviceToken');
    return true;
  }

  @override
  Future<bool> linkDevice(String deviceToken) async {
    await dio.put(
      '/user/link/device',
      data: {'token': deviceToken},
    );
    return true;
  }
}
