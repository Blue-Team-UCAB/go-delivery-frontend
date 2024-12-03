import 'package:go_delivery_frontend/domain/datasources/cart/cart_local_storage_datasource.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_local_storage_repository.dart';

class CartLocalStorageRepositoryImpl extends CartLocalStorageRepository{

  final CartLocalStorageDatasource datasource;

  CartLocalStorageRepositoryImpl(this.datasource);

  @override
  Future<void> addCartItem(CartItem item) {
    return datasource.addCartItem(item);
  }

  @override
  Future<void> removeCartItem(String id) {
    return datasource.removeCartItem(id);
  }

  @override
  Future<List<CartItem>> loadCartItems() {
    return datasource.loadCartItems();
  }

  @override
  Future<void> operateCartItem(String id, int quantity){
    return datasource.operateCartItem(id, quantity);
  }
  
}