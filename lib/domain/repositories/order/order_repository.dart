import 'package:go_delivery_frontend/infrastructure/models/tracking_model.dart';

import '../../../common/result.dart';
import '../../../infrastructure/models/order_many_model.dart';
import '../../entities/order/order.dart';

abstract class OrderRepository {
  Future<Result<Order>> getOrderById(String orderId);

  // Cancela una orden
  Future<Result<bool>> cancelOrder(String orderId, {String? reason});

  Future<Result<List<OrderManyItem>>> getOrders({
    required int page,
    required int perpage,
    required String status,
  });

}