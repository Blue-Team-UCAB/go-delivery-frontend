import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_get_ai_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/bundle/bundle_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/cart/cart_item_mapper.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/product/product_mapper.dart';

class CartGetAiRepositoryImpl extends CartGetAiRepository{
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  CartGetAiRepositoryImpl({
    required IApiRequestManager apiRequestManager, 
    required LocalStorage localStorage
    }) :_apiRequestManager = apiRequestManager, 
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<CartItem>>> loadAICart() async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/ia/random/card',
        'POST',
        (data) {
          // final List<CartItem> items = [];
          final List productsJson = data['products'].toList();
          final List bundlesJson = data['combos'].toList();
          final List<Product> products = ProductMapper.fromJsonList(productsJson);
          final List<Bundle> bundles = BundleMapper.fromJsonList(bundlesJson);
          final List<CartItem> items = [
            ...products.map((product)=>CartItemMapper.fromProduct(product).toCartItemEntity()),
            ...bundles.map((bundle)=>CartItemMapper.fromBundle(bundle).toCartItemEntity())
            ];
          return items;
        },
      );
      return response ;
    } catch (e) {
      print('Error in CartGetAiRepositoryImpl.loadAICart: $e');
      rethrow;
    }
  }
}