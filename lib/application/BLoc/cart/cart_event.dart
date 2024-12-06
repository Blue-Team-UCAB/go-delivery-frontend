part of 'cart_bloc.dart';


sealed class CartEvent extends Equatable{

  const CartEvent();

  @override
  List<Object> get props => [];

}

final class AddCartItem extends CartEvent{
  final CartItem item;
  const AddCartItem(this.item);
}

final class PlusOneQuantity extends CartEvent {
  final String id;
  const PlusOneQuantity(this.id);
}

final class MinusOneQuantity extends CartEvent {
  final String id;
  const MinusOneQuantity(this.id);
}

final class DeleteCartItem extends CartEvent{
  final CartItem item;
  const DeleteCartItem(this.item);
}

final class EmptyCart extends CartEvent {
  const EmptyCart();
}
