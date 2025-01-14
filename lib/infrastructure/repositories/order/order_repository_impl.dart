import 'package:go_delivery_frontend/infrastructure/mappers/order/checkout/bundlecheckout_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/checkout/productcheckout_mapper.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/order/order.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/order/order_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/many/many_order_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/order/order_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/models/order_many_model.dart';

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
        '/api/order/user/many/?status=$status', 'GET', queryParameters: queryParameters,
        (data) {
      return OrderManyMapper.fromJson(data).orders;
    });
    return response;
  }

  @override
  Future<Result<Order>> getOrderById(String orderId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/order/$orderId',
        'GET',
        (data) {
          final order = OrderMapper.fromJson(data);
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
  Future<Result<bool>> createOrder({
    String? paymentId,
    String? stripePaymentMethod,
    String? paymentMethod,
    String? couponId,
    required String idUserDirection,
    required List<CheckoutProduct> products,
    List<CheckoutBundle>? bundles
  }) async {
    await _addAuthorizationHeader();

    // Prepare the body
    final body = {
      'idUserDirection': idUserDirection,
      'products': CheckoutProductMapper.toJsonList(products),
      if (bundles != null) 'bundles': CheckoutBundleMapper.toJsonList(bundles),
      if (paymentId != null) 'paymentId': paymentId,
      if (stripePaymentMethod != null) 'stripePaymentMethod': stripePaymentMethod,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (couponId != null) 'couponId': couponId,
    };

    final response = await _apiRequestManager.request(
      '/api/order/pay/stripe',
      'POST',
          (data) {
        if (data is Map<String, dynamic>) {
          if (data.containsKey('error')) {
            return false;
          } else {
            return true;
          }
        }
        return false;
      },
      body: body,
    );

    if (response.isSuccess) {
      if (response.value == true) {
        return Result.success(true);
      } else {
        final message = response.error?.toString() ?? 'Algo Ocurrió en el checkout';
        return Result.fail(CustomFailure(message: message));
      }
    } else {
      final message = response.error?.toString() ?? 'Algo Ocurrió en el checkout';
      return Result.fail(CustomFailure(message: message));
    }
  }

  @override
  Future<Result<bool>> cancelOrder(String orderId) async {
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request(
      '/api/order/cancel',
      'POST',
      (data) {
          return true;
      },
      body: {'orderId': orderId},
    );
    if (response.isSuccess) {
        return Result.success(true);
    } else {
      return Result.fail(CustomFailure(message: response.error!.message.toString()));
    }
  }

  @override
  Future<Result<bool>> reportOrder({
    required String orderId,
    required String desc
  }) async {

    await _addAuthorizationHeader();

    final response = await _apiRequestManager.request(
      '/api/order/report',
      'POST',
          (data) {
            return true;
      },
      body: {
        'orderId': orderId,
        'description': desc
      },
    );
    if (response.isSuccess) {
      return Result.success(true);
    } else {
      return Result.fail(CustomFailure(message: response.error!.message.toString()));
    }
  }
}
