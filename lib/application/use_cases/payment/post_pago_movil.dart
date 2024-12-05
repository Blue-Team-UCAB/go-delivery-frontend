import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';
import 'package:go_delivery_frontend/domain/repositories/payment/payment_method_repository.dart';

class ProcessPagoMovilInput extends IUseCaseInput {
  final String reference;
  final String phone;
  final String cedula;
  final String bank;
  final double amount;
  final DateTime date;

  ProcessPagoMovilInput({
    required this.reference,
    required this.phone,
    required this.cedula,
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
      reference: input.reference,
      amount: input.amount,
      date: input.date,
      phone: input.phone,
      cedula: input.cedula,
      bank: input.bank,
    );
    return _paymentRepository.processPagoMovil(pagoMovil);
  }
}
