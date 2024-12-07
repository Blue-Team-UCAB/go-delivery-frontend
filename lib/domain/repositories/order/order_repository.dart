import '../../../common/result.dart';
import '../../../infrastructure/models/order_many_model.dart';
import '../../entities/bundle/bundle.dart';
import '../../entities/order/order.dart';
import '../../entities/product/product.dart';

abstract class OrderRepository {
  Future<Result<Order>> getOrderById(String orderId);

  // Cancela una orden
  Future<Result<bool>> cancelOrder(String orderId, {String? reason});

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
}
