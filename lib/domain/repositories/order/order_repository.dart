import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/courier/courier.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';

abstract class OrderRepository {
  Future<Result<Order>> getOrderById(String orderId);

  Future<Result<bool>> cancelOrder(String orderId);

  Future<Result<List<OrderManyItem>>> getOrders({
    required int page,
    required int perpage,
    required String status,
  });

  Future<Result<Order>> createOrder(
      {String? paymentId,
      String? stripePaymentMethod,
      String? paymentMethod,
      String? couponId,
      required String idUserDirection,
      required List<CheckoutProduct> products,
      List<CheckoutBundle>? bundles,
      String? currency});

  Future<Result<bool>> reportOrder(
      {required String orderId, required String desc});

  Future<Result<CourierPosition>> courierPositionOrder(String orderId);
}
