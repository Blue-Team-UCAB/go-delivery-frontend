import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';

abstract class CartGetAiRepository {

  Future<Result<List<CartItem>>> loadAICart();
}