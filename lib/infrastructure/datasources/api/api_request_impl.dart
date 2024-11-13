import 'package:dio/dio.dart';
import '../../../application/api/api_request.dart';
import '../../../common/failure.dart';
import '../../../common/result.dart';

class ApiRequestManagerImpl extends IApiRequestManager {
  final Dio _dio;

  ApiRequestManagerImpl({
    required super.baseDirection,
  }) : _dio = Dio(BaseOptions(baseUrl: baseDirection));

  @override
  Future<Result<T>> request<T>(
    String path,
    String method,
    T Function(dynamic) mapper, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(path,
          data: body,
          options: Options(method: method),
          queryParameters: queryParameters);

      print('Response data in request: ${response.data}');
      return Result.success(mapper(response.data));
    } on DioException catch (e) {
      print('DioError in request: $e');
      return Result.fail(handleException(e));
    } catch (e) {
      print('Error in request: $e');
      return Result.fail(const UnknownFailure());
    }
  }

  // Método para manejar las excepciones de Dio
  Failure handleException(DioException e) {
    print('Handling DioError: $e');
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NoInternetFailure();
      case DioExceptionType.badResponse:
        if (e.response?.data['message'] is String) {
          print("Error en autorización");
          return NoAuthorizeFailure(message: e.response?.data['message']);
        } else {
          return const NoAuthorizeFailure(message: 'Error desconocido');
        }
      case DioExceptionType.connectionError:
        if (e.message?.contains('SocketException') ?? false) {
          return const NoInternetFailure();
        }
        return const UnknownFailure();
      default:
        return const UnknownFailure();
    }
  }

  @override
  void setHeaders(String key, dynamic value) =>
      _dio.options.headers[key] = value;

  @override
  Map<String, dynamic> getHeaders() => _dio.options.headers;
}
