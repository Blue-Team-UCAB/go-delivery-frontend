import '../../../common/result.dart';
import '../../../common/use_cases.dart';
//import '../../../domain/entities/category/category.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/repositories/order/order_repository.dart';

class GetOneOrderUseCaseInput extends IUseCaseInput {
  final String orderId;

  GetOneOrderUseCaseInput({required this.orderId});
}

class GetOneOrderUseCase {
  final OrderRepository _orderRepository;

  GetOneOrderUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<Order>> execute(GetOneOrderUseCaseInput input) async {
    return _orderRepository.getOrderById(input.orderId);
  }
}
