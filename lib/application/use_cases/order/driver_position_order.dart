import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';

import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';

class GetDriverPositionOrderUseCaseInput extends IUseCaseInput {
  final String id;

  GetDriverPositionOrderUseCaseInput({
    required this.id,
  });
}

class GetDriverPositionOrderUseCase {
  final OrderRepository _orderRepository;

  GetDriverPositionOrderUseCase({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Future<Result<CourierPosition>> execute(
      GetDriverPositionOrderUseCaseInput input) async {
    return _orderRepository.courierPositionOrder(input.id);
  }
}