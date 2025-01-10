import '../../../common/result.dart';
import '../../../common/use_cases.dart';
import '../../../domain/repositories/order/order_repository.dart';

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