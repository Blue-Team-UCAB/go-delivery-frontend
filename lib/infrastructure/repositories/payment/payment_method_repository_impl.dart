import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/payment/payment_method_mapper.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  PaymentRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<bool>> processPagoMovil(PagoMovil pagoMovil) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<bool>(
      '/api/payment/method/recharge/pago-movil',
      'POST',
      (data) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error') || data['errorCode'] != 200) {
            return false; // Indica un fallo en el proceso
          }
          return true; // Proceso exitoso
        }
        return false;
      },
      body: PaymentMethodMapper.toJson(pagoMovil),
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(
            CustomFailure(message: 'Error al procesar PagoMovil'));
      }
    } else {
      return response; // Retorna el error gestionado por `IApiRequestManager`
    }
  }

  @override
  Future<Result<bool>> processZelle(Zelle zelle) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<bool>(
      '/api/payment/method/recharge/zelle',
      'POST',
      (data) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error') || data['errorCode'] != 200) {
            return false; // Indica un fallo en el proceso
          }
          return true; // Proceso exitoso
        }
        return false;
      },
      body: PaymentMethodMapper.toJson(zelle),
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(CustomFailure(message: 'Error al procesar Zelle'));
      }
    } else {
      return response; // Retorna el error gestionado por `IApiRequestManager`
    }
  }

  @override
  Future<Result<bool>> processCard(Card card) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<bool>(
      '/api/payment/method/user/add/card',
      'POST',
      (data) {
        if (data is Map<String, dynamic> && !data.containsKey('error')) {
          return true;
        }
        return false;
      },
      body: {'idCard': card.idCard},
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        return Result.fail(
            CustomFailure(message: 'Error al agregar la tarjeta'));
      }
    } else {
      return response;
    }
  }

  @override
  Future<Result<List<Card>>> getCard() async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<List<Card>>(
      '/api/payment/method/user/card/many',
      'GET',
      (data) {
        if (data is List) {
          return data
              .map((item) => PaymentMethodMapper.cardFromJson(item))
              .toList();
        }
        throw Exception('Respuesta inesperada');
      },
    );

    if (response.isSuccess) {
      return Result.success(response.getValue());
    } else {
      return response;
    }
  }

  @override
  Future<Result<bool>> deleteCard(String cardId) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request<bool>(
      '/api/payment/method/user/card/delete/$cardId',
      'DELETE',
      (data) {
        if (data is Map<String, dynamic> && !data.containsKey('error')) {
          return true;
        }
        return false;
      },
    );
    if (response.isSuccess) {
      return Result.success(response.value ?? false);
    } else {
      return Result.fail(
        CustomFailure(message: 'Error desconocido al eliminar la tarjeta'),
      );
    }
  }

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() async {
    final response = await _apiRequestManager.request<List<PaymentMethod>>(
      '/api/payment/method/many',
      'GET',
      (data) {
        if (data is List) {
          return data
              .map((item) => PaymentMethodMapper.fromJson(item))
              .toList();
        }
        throw Exception('Unexpected response format');
      },
    );

    if (response.isSuccess) {
      return Result.success(response.getValue());
    } else {
      return response;
    }
  }
}
