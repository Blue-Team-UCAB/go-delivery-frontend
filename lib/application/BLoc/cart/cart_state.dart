part of 'cart_bloc.dart';


class CartState extends Equatable {

  final List<CartItem> items;

  const CartState({
    this.items = const []
  });

  int get howManyItems => items.length;

  double get totalPrice {
    double result = 0;
    for (var item in items) {
      result += (item.quantity*item.price);
    }
    return double.parse(result.toStringAsFixed(2));
  }

  CartState copyWith({
    List<CartItem>? items
  }) {
    return CartState(
      items : items ?? this.items
    );
  }


  @override
  List<Object> get props => [items];

}
