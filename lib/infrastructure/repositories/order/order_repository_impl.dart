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
  Future<Result<bool>> createOrder(
      {required String direction,
      required double longitude,
      required double latitude,
      String? tokenStripe,
      String? idCoupon,
      required List<CheckoutProduct> products,
      List<CheckoutBundle>? bundles}) async {
    await _addAuthorizationHeader();

    // Prepare the body
    final body = {
      'direction': direction,
      'longitude': longitude,
      'latitude': latitude,
      if (tokenStripe != null) 'token_stripe': tokenStripe,
      if (idCoupon != null) 'id_coupon': idCoupon,
      'products': CheckoutProductMapper.toJsonList(products),
      if (bundles != null && bundles.isNotEmpty)
        'bundles': CheckoutBundleMapper.toJsonList(bundles),
    };
    var message = '';

    print("APPLIED COUPON: ${body["id_coupon"]}");

    final response = await _apiRequestManager.request(
      '/order',
      'POST',
      (data) {
        if (data['errorCode'] != 200) {
          message = data["message"];
          return false;
        } else {
          return true;
        }
      },
      body: body,
    );
    if (response.value == true) {
      return response;
    } else {
      return Result.fail(CustomFailure(message: message));
    }
  }

  @override
  Future<Result<bool>> cancelOrder(String orderId) async {
    var message;
    await _addAuthorizationHeader();
    final response = await _apiRequestManager.request(
      '/order/cancel',
      'POST',
      (data) {
        if (data['errorCode'] != 200) {
          message = data["message"];
          return false;
        } else {
          return true;
        }
      },
      body: {'orderId': orderId},
    );
    if (response.value == true) {
      return response;
    } else {
      return Result.fail(CustomFailure(message: message));
    }
  }
}
