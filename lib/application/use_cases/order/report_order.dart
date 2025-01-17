import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';

class ReportOneOrderUseCaseInput extends IUseCaseInput {
  final String orderId;
  final String desc;

  ReportOneOrderUseCaseInput({required this.orderId, required this.desc});
}

class ReportOneOrderUseCase {
  final OrderRepository _orderRepository;

  ReportOneOrderUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<bool>> execute(ReportOneOrderUseCaseInput input) async {
    return _orderRepository.reportOrder(orderId: input.orderId, desc: input.desc);
  }
}