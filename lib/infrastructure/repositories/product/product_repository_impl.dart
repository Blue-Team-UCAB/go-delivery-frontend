import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/product_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';

class ProductRepositoryImpl extends ProductRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  ProductRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<Product>>> getProducts({
    String? name,
    List<String>? categories,
    int? price,
    String? discount,
    String? popular,
    required int page,
    required int perpage,
  }) async {
    print("______ PRODUCT MANY ______");

    final queryParameters = <String, dynamic>{
      'page': page.toString(),
      'perpage': perpage.toString(),
    };

    if (name != null && name.trim().isNotEmpty) {
      queryParameters['name'] = name.trim();
    }

    if (categories != null &&
        categories.isNotEmpty &&
        categories.any((category) => category.trim().isNotEmpty)) {
      queryParameters['category'] = categories.join(',');
    }

    if (price != null && price > 0) {
      queryParameters['price'] = price;
    }

    if (discount != null && discount.isNotEmpty) {
      queryParameters['discount'] = discount;
    }

    if (popular != null && popular.isNotEmpty) {
      queryParameters['popular'] = popular;
    }

    print('Query Parameters:');
    queryParameters.forEach((key, value) {
      print('  - $key: $value');
    });

    final response = await _apiRequestManager.request(
      '/api/product/many',
      'GET',
      queryParameters: queryParameters,
      (data) {
        if (data == null) {
          throw FormatException(
              'Invalid response format: products data is missing');
        }
        try {
          return ProductMapper.fromJsonList(data);
        } catch (e) {
          throw FormatException('Failed to parse products: ${e.toString()}');
        }
      },
    );

    return response;
  }

  @override
  Future<Result<Product>> getProductById(String productId) async {
    await _addAuthorizationHeader();

    print("______ PRODUCT BY ID ______");

    final response = await _apiRequestManager.request(
      '/api/product/$productId',
      'GET',
      (data) {
        final product = ProductMapper.fromJsonDetail(data, productId);
        return product;
      },
    );
    return response;
  }
}
