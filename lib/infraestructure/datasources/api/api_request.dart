import 'package:go_delivery_frontend/common/result.dart';

abstract class IApiRequestManager {
  final String baseUrl;
  IApiRequestManager({required this.baseUrl});

  Future<Result<T>> request<T>(
      String path, String method, T Function(dynamic) mapper,
      {dynamic body, Map<String, dynamic>? queryParameters});
  void setHeaders(String key, dynamic value);
  Map<String, dynamic> getHeaders();
}
