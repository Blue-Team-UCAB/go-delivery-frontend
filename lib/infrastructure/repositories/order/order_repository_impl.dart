import 'package:go_delivery_frontend/infrastructure/models/tracking_model.dart';

import '../../../application/api/api_request.dart';
import '../../../application/key_value_storage/key_value.dart';
import '../../../common/result.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/repositories/order/order_repository.dart';
import '../../mappers/order/order_mapper.dart';

class OrderRepositoryImpl extends OrderRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  OrderRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<Order>>> getOrders({
    required int page,
    required int take,
  }) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/orders',
        'GET',
        queryParameters: {
          'page': page.toString(),
          'take': take.toString(),
        },
            (data) {
          List<Order> orders = (data['orders'] as List)
              .map((orderData) => OrderMapper.fromJson(orderData))
              .toList();
          return orders;
        },
      );
      return response;
    } catch (e) {
      print('Error in OrderRepositoryImpl.getOrders: $e');
      rethrow;
    }
  }

  @override
  Future<Result<Order>> getOrderById(String orderId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/orders/$orderId',
        'GET',
            (data) {
          print('API response for order: $data');
          final order = OrderMapper.fromJson(data);
          print('Products in the order:');
          order.products.forEach((product) {
            print('Product: ${product.name}, Price: ${product.price}');
          });
          return order;
        },
      );
      return response;
    } catch (e) {
      print('Error in OrderRepositoryImpl.getOrderById: $e');
      rethrow;
    }
  }

  @override
  Future<Result<bool>> cancelOrder(String orderId, {String? reason}) {
    // TODO: implement cancelOrder
    throw UnimplementedError();
  }

  @override
  Future<Result<InvoiceDownloadInfo>> downloadInvoice(String orderId) {
    // TODO: implement downloadInvoice
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Order>>> getOrderHistory({int page = 1, int limit = 10, String? status}) {
    // TODO: implement getOrderHistory
    throw UnimplementedError();
  }

  @override
  Future<Result<Order>> modifyOrderQuantity({required String orderId, required String productId, required int newQuantity}) {
    // TODO: implement modifyOrderQuantity
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> rateOrder({required String orderId, required int rating, String? review}) {
    // TODO: implement rateOrder
    throw UnimplementedError();
  }

  @override
  Future<Result<Order>> reorderPreviousOrder(String originalOrderId) {
    // TODO: implement reorderPreviousOrder
    throw UnimplementedError();
  }

  @override
  Future<Result<TrackingInfo>> trackOrderStatus(String orderId) {
    // TODO: implement trackOrderStatus
    throw UnimplementedError();
  }

  @override
  Future<Result<Order>> updateOrderStatus({required String orderId, required String newStatus}) {
    // TODO: implement updateOrderStatus
    throw UnimplementedError();
  }
}