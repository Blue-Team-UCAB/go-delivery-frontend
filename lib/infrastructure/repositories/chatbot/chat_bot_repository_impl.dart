import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';

abstract class ChatBotRepository {
  Future<Result<String>> sendMessage({
    required String userId,
    required String message,
    String? context,
  });
}

class ChatBotRepositoryImpl extends ChatBotRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  ChatBotRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<String>> sendMessage({
    required String userId,
    required String message,
    String? context, // Nuevo parámetro
  }) async {
    await _addAuthorizationHeader();

    final response = await _apiRequestManager.request<Map<String, dynamic>>(
      '/api/ia/make/request',
      'POST',
      (data) {
        if (data is Map<String, dynamic> && data.containsKey('response')) {
          return {'response': data['response'] as String};
        }
        throw Exception('Formato de respuesta inválido');
      },
      body: {
        'user_id': userId,
        'message': message,
        'context': context,
      },
    );

    if (response.isSuccess) {
      final responseData = response.getValue();
      final messageResponse = responseData['response'] as String;
      return Result.success(messageResponse);
    } else {
      return Result.fail(
        CustomFailure(message: 'Error al enviar el mensaje al backend'),
      );
    }
  }
}
