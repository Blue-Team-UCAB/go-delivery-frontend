import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

class GetPaymentMethodsUseCaseInput extends IUseCaseInput {}

class GetPaymentMethodsUseCase {
  final PaymentRepository _paymentRepository;

  GetPaymentMethodsUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  Future<Result<List<PaymentMethod>>> execute(
      GetPaymentMethodsUseCaseInput input) {
    return _paymentRepository.getPaymentMethods();
  }
}
