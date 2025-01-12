import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_card.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_zelle.dart';
import 'package:go_delivery_frontend/domain/entities/payment/payment_method_pago_movil.dart';

abstract class PaymentRepository {
  Future<Result<void>> processPagoMovil(PagoMovil pagoMovil);
  Future<Result<void>> processZelle(Zelle zelle);
  Future<Result<void>> processCard(Card card);
  Future<Result<List<Card>>> getCard();
  Future<Result<void>> deleteCard(String cardId);
  Future<Result<List<PaymentMethod>>> getPaymentMethods();
}
