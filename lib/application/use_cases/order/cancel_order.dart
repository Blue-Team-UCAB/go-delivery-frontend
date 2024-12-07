import '../../../common/result.dart';
import '../../../common/use_cases.dart';
import '../../../domain/repositories/order/order_repository.dart';

class CancelOneOrderUseCaseInput extends IUseCaseInput {
  final String orderId;

  CancelOneOrderUseCaseInput({required this.orderId});
}

class CancelOneOrderUseCase {
  final OrderRepository _orderRepository;

  CancelOneOrderUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<bool>> execute(CancelOneOrderUseCaseInput input) async {
    return _orderRepository.cancelOrder(input.orderId);
  }
}