import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
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
  Future<Result<dynamic>> processPagoMovil(PagoMovil pagoMovil) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/recharge/pago-movil',
        'POST',
        (data) => PaymentMethodMapper.parseApiResponse(data),
        body: PaymentMethodMapper.toJson(pagoMovil),
      );

      if (response.isSuccessful()) {
        final responseData = response.getValue();

        final errorCode = responseData['errorCode'];
        final message = responseData['message'];
        if (errorCode == 200 && message == null) {
          return Result.success(responseData);
        }
        if (errorCode == 400 && message == 'Payment failed') {
          return Result.fail(
              BadReponseFailure(message: 'Pago fallido: $message'));
        }
        return Result.fail(BadReponseFailure(
            message: 'Pago fallido: Respuesta inesperada del servidor'));
      } else {
        return Result.fail(const ServerFailure());
      }
    } catch (e) {
      print('Error en PaymentRepositoryImpl.processPagoMovil: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al procesar PagoMovil: $e'));
    }
  }

  @override
  Future<Result<dynamic>> processZelle(Zelle zelle) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/recharge/zelle',
        'POST',
        (data) => PaymentMethodMapper.parseApiResponse(data),
        body: PaymentMethodMapper.toJson(zelle),
      );

      if (response.isSuccessful()) {
        final responseData = response.getValue();

        final errorCode = responseData['errorCode'];
        final message = responseData['message'];

        if (errorCode == 200 && message == null) {
          return Result.success(responseData);
        }

        if (errorCode == 400 && message == 'Payment failed') {
          return Result.fail(
              BadReponseFailure(message: 'Pago fallido: $message'));
        }

        return Result.fail(BadReponseFailure(
            message: 'Pago fallido: Respuesta inesperada del servidor'));
      } else {
        return Result.fail(const ServerFailure());
      }
    } catch (e) {
      print('Error en PaymentRepositoryImpl.processZelle: $e');
      return Result.fail(ServerFailure(message: 'Fallo al procesar Zelle: $e'));
    }
  }

  @override
  Future<Result<dynamic>> processCard(Card card) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/user/add/card',
        'POST',
        (data) => data,
        body: {'idCard': card.idCard},
      );

      if (response.isSuccess) {
        return Result.success('Funciono');
      } else {
        return Result.fail(
            const ServerFailure(message: 'Error al procesar la tarjeta'));
      }
    } catch (e) {
      print('Error en PaymentRepositoryImpl.processCard: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al procesar el pago con tarjeta: $e'));
    }
  }

  @override
  Future<Result<List<Card>>> getCard() async {
    await _addAuthorizationHeader();

    try {
      final result = await _apiRequestManager.request(
        '/api/payment/method/user/card/many',
        'GET',
        (data) => (data as List)
            .map((item) => PaymentMethodMapper.cardFromJson(item))
            .toList(),
      );

      if (result.isSuccessful()) {
        final cards = result.getValue();
        return Result.success(cards);
      } else {
        return Result.fail(result.getError());
      }
    } catch (e) {
      print('Error in PaymentMethodRepositoryImpl.getCard: $e');
      return Result.fail(Exception('Failed to fetch cards: $e') as Failure);
    }
  }

  @override
  Future<Result<dynamic>> deleteCard(String cardId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/payment/method/user/card/delete/$cardId',
        'DELETE',
        (data) => data,
      );

      if (response.isSuccessful()) {
        return Result.success(true);
      } else {
        return Result.fail(
            const ServerFailure(message: 'Error al eliminar la tarjeta'));
      }
    } catch (e) {
      print('Error en PaymentRepositoryImpl.deleteCard: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al eliminar la tarjeta: $e'));
    }
  }
}
