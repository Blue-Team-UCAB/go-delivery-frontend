import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';

class GetCardUseCaseInput extends IUseCaseInput {
  GetCardUseCaseInput();
}

class GetUserCardsUseCase implements IUseCase<GetCardUseCaseInput, List<Card>> {
  final PaymentRepository _paymentRepository;

  GetUserCardsUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  @override
  Future<Result<List<Card>>> execute(GetCardUseCaseInput input) {
    return _paymentRepository.getCard();
  }
}
