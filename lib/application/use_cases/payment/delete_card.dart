import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

class DeleteCardUseCaseInput extends IUseCaseInput {
  final String cardId;

  DeleteCardUseCaseInput({required this.cardId});
}

class DeleteCardUseCase implements IUseCase<DeleteCardUseCaseInput, void> {
  final PaymentRepository _paymentRepository;

  DeleteCardUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  @override
  Future<Result<void>> execute(DeleteCardUseCaseInput input) {
    return _paymentRepository.deleteCard(input.cardId);
  }
}
