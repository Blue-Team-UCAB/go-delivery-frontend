import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/payment/payment_mapper.dart';
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
  Future<Result<void>> processPagoMovil(PagoMovil pagoMovil) async {
    await _addAuthorizationHeader();
    try {
      // Realizamos la solicitud al servidor
      final response = await _apiRequestManager.request(
        '/pay/pago-movil',
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
  Future<Result<void>> processZelle(Zelle zelle) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/pay/zelle',
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
  Future<Result<void>> processCard(Card card) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/pay/card',
        'POST',
        (data) => PaymentMethodMapper.parseApiResponse(data),
        body: {'idCard': card.idCard},
      );
      return response;
    } catch (e) {
      print('Error en PaymentRepositoryImpl.processCard: $e');
      return Result.fail(
          ServerFailure(message: 'Fallo al procesar el pago con tarjeta: $e'));
    }
  }
}
