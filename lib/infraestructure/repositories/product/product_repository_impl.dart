import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/product/product_repository.dart';
import 'package:go_delivery_frontend/infraestructure/datasources/api/api_request.dart';
import 'package:go_delivery_frontend/infraestructure/mappers/product/product_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

class ProductRepositoryImpl extends ProductRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  ProductRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  //Future<void> _addAuthorizationHeader() async {
  //  final token = await _localStorage.getAuthorizationToken();
  //  _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  //}

  @override
  Future<Result<List<Product>>> getProducts({
    required int page,
    required int perPage,
    required String category,
  }) async {
    //await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/product',
        'GET',
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
      rethrow;
    }
  }
}
