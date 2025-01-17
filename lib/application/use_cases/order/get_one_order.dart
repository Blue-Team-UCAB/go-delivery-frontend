import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
//import '../../../domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';

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
