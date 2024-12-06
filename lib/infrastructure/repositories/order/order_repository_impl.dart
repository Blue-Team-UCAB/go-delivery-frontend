import '../../../application/api/api_request.dart';
import '../../../application/key_value_storage/key_value.dart';
import '../../../common/result.dart';
import '../../../domain/entities/order/order.dart';
import '../../../domain/repositories/order/order_repository.dart';
import '../../mappers/order/many/many_order_mapper.dart';
import '../../mappers/order/order_mapper.dart';
import '../../models/order_many_model.dart';

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
  Future<Result<List<OrderManyItem>>> getOrders({
    required int page,
    required int perpage,
    required String status,
  }) async {
    await _addAuthorizationHeader();

    Map<String, String> queryParameters = {
      'page': page.toString(),
      'perpage': perpage.toString(),
    };

    final response = await _apiRequestManager.request(
        '/order?status=$status', 'GET', queryParameters: queryParameters,
        (data) {
      return OrderManyMapper.fromJson(data['value']).orders;
    });
    return response;
  }

  @override
  Future<Result<Order>> getOrderById(String orderId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/order/$orderId',
        'GET',
        (data) {
          final order = OrderMapper.fromJson(data["value"]);
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
}
