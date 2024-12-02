import 'package:go_delivery_frontend/infrastructure/models/tracking_model.dart';

import '../../../common/result.dart';
import '../../entities/order/order.dart';

abstract class OrderRepository {
  Future<Result<Order>> getOrderById(String orderId);

  // Cancela una orden
  Future<Result<bool>> cancelOrder(String orderId, {String? reason});

  Future<Result<List<Order>>> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? status,
  });

  // Reorder
  Future<Result<Order>> reorderPreviousOrder(String originalOrderId);

  Future<Result<TrackingInfo>> trackOrderStatus(String orderId);

  Future<Result<InvoiceDownloadInfo>> downloadInvoice(String orderId);

  Future<Result<Order>> updateOrderStatus({
    required String orderId,
    required String newStatus
  });

  Future<Result<Order>> modifyOrderQuantity({
    required String orderId,
    required String productId,
    required int newQuantity
  });

  Future<Result<bool>> rateOrder({
    required String orderId,
    required int rating,
    String? review
  });
}