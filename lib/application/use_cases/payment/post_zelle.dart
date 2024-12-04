import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

class ProcessZelleInput extends IUseCaseInput {
  final String email;
  final double amount;
  final String reference;

  ProcessZelleInput({
    required this.email,
    required this.amount,
    required this.reference,
  });
}

class ProcessZelleUseCase implements IUseCase<ProcessZelleInput, void> {
  final PaymentRepository _paymentRepository;

  ProcessZelleUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  @override
  Future<Result<void>> execute(ProcessZelleInput input) {
    final zelle = Zelle(
      amount: input.amount,
      date: DateTime.now(),
      email: input.email,
      reference: input.reference,
    );
    return _paymentRepository.processZelle(zelle);
  }
}
