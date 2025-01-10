import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class OrderRepository {
  Future<Result<Order>> getOrderById(String orderId);

  // Cancela una orden
  Future<Result<bool>> cancelOrder(String orderId);

  Future<Result<List<OrderManyItem>>> getOrders({
    required int page,
    required int perpage,
    required String status,
  });

  Future<Result<bool>> createOrder({
    required String direction,
    required double longitude,
    required double latitude,
    String? tokenStripe,
    String? idCoupon,
    required List<CheckoutProduct> products,
    List<CheckoutBundle>? bundles
  });

  Future<Result<bool>> reportOrder({
    required String orderId,
    required String desc
   });
}
