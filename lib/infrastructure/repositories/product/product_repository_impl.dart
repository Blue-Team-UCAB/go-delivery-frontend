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
    String? category,
    required int page,
    required int perpage,
  }) async {
    await _addAuthorizationHeader();

    try {
      Map<String, String> queryParameters = {
        'page': page.toString(),
        'perpage': perpage.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      if (category?.isNotEmpty ?? false) {
        queryParameters['category'] = category!;
      }

      final response = await _apiRequestManager.request(
        '/api/product',
        'GET',
        queryParameters: queryParameters,
        (data) {
          List<Product> products = (data['products'] as List)
              .map((productData) => ProductMapper.fromJson(productData))
              .toList();
          return products;
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
