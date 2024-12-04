import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

class ProcessPagoMovilInput extends IUseCaseInput {
  final String phone;
  final String idDocument;
  final String bank;
  final double amount;
  final DateTime date;

  ProcessPagoMovilInput({
    required this.phone,
    required this.idDocument,
    required this.bank,
    required this.amount,
    required this.date,
  });
}

class ProcessPagoMovilUseCase {
  final PaymentRepository _paymentRepository;

  ProcessPagoMovilUseCase({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository;

  Future<Result<void>> execute(ProcessPagoMovilInput input) {
    final pagoMovil = PagoMovil(
      amount: input.amount,
      date: input.date,
      phone: input.phone,
      idDocument: input.idDocument,
      bank: input.bank,
    );
    return _paymentRepository.processPagoMovil(pagoMovil);
  }
}
