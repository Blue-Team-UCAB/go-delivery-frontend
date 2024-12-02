import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';


abstract class CartLocalStorageRepository {

  Future<void> addCartItem(CartItem item);

  Future<void> removeCartItem(String id);
  
  Future<void> operateCartItem(String id, int quantity);

  Future<List<CartItem>> loadCartItems();
}