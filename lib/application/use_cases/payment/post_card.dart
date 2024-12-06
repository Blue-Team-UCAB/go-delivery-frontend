import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';

class ProcessCardPaymentInput extends IUseCaseInput {
  final String idCard;

  ProcessCardPaymentInput({required this.idCard});
}

class ProcessCardPaymentUseCase {
  final PaymentRepository _paymentRepository;

  ProcessCardPaymentUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  Future<Result<void>> execute(ProcessCardPaymentInput input) {
    final card = Card(idCard: input.idCard);
    return _paymentRepository.processCard(card);
  }
}
