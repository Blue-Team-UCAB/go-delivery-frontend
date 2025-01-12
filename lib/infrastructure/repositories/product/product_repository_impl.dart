import 'package:go_delivery_frontend/common/failure.dart';
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
    String? search,
    List<String>? categories,
    String? price,
    String? discount,
    String? popular,
    required int page,
    required int perpage,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page.toString(),
        'perpage': perpage.toString(),
      };

      // Add optional parameters conditionally
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      if (categories != null && categories.isNotEmpty) {
        // Join categories into a comma-separated string if the API expects it
        queryParameters['category'] = categories.join(',');
      }

      if (price != null && price.isNotEmpty) {
        queryParameters['price'] = price;
      }

      if (discount != null && discount.isNotEmpty) {
        queryParameters['discount'] = discount;
      }

      if (popular != null && popular.isNotEmpty) {
        queryParameters['popular'] = popular;
      }

      // Perform the API request
      final response = await _apiRequestManager.request(
        '/api/product/many',
        'GET',
        queryParameters: queryParameters,
            (data) {
          // Robust parsing with error handling
          if (data == null || data['products'] == null) {
            throw FormatException('Invalid response format: products data is missing');
          }

          try {
            return (data['products'] as List)
                .map((productData) => ProductMapper.fromJson(productData))
                .toList();
          } catch (e) {
            throw FormatException('Failed to parse products: ${e.toString()}');
          }
        },
      );

      return response;
    } catch (e) {
      print('Error in ProductRepositoryImpl.getProducts: $e');
      return Result.fail(Exception('Failed to fetch products: $e') as Failure);
    }
  }

  @override
  Future<Result<Product>> getProductById(String productId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/product/$productId',
        'GET',
        (data) {
          final product = ProductMapper.fromJson(data);
          return product;
        },
      );
      return response;
    } catch (e) {
      print('Error in ProductRepositoryImpl.getProductById: $e');
      rethrow;
    }
  }
}
