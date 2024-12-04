import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/payment/payment_mapper.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

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
      final response = await _apiRequestManager.request(
        '/payment/method/pagomovil',
        'POST',
        (data) => Result.success(data),
        body: PaymentMethodMapper.toJson(pagoMovil),
      );
      return response;
    } catch (e) {
      print('Error in PaymentRepositoryImpl.processPagoMovil: $e');
      return Result.fail(
          Exception('Failed to process PagoMovil: $e') as Failure);
    }
  }

  @override
  Future<Result<void>> processZelle(Zelle zelle) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/payment/method/zelle',
        'POST',
        (data) => Result.success(data),
        body: PaymentMethodMapper.toJson(zelle),
      );
      return response;
    } catch (e) {
      print('Error in PaymentRepositoryImpl.processZelle: $e');
      return Result.fail(Exception('Failed to process Zelle: $e') as Failure);
    }
  }
}
