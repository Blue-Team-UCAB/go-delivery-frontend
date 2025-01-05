import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';

import '../../../common/result.dart';
import '../../../common/use_cases.dart';
import '../../../domain/repositories/order/order_repository.dart';

class GetManyOrdersUseCaseInput extends IUseCaseInput {
  final int page;
  final int perpage;
  final String status;

  GetManyOrdersUseCaseInput({
    required this.page,
    required this.perpage,
    required this.status,
  });
}

class GetManyOrdersUseCase {
  final OrderRepository _orderRepository;

  GetManyOrdersUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<List<OrderManyItem>>> execute(
      GetManyOrdersUseCaseInput input) async {
    return _orderRepository.getOrders(
      page: input.page,
      perpage: input.perpage,
      status: input.status,
    );
  }
}
