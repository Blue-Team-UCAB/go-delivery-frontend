import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_get_ai_repository.dart';
import 'package:go_delivery_frontend/domain/repositories/cart/cart_local_storage_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartLocalStorageRepository _cartLocalStorageRepository;
  final CartGetAiRepository _cartGetAiRepository;

  CartBloc(this._cartLocalStorageRepository, this._cartGetAiRepository)
      : super(const CartState(items: [])) {
    loadCartItems();
    on<AddCartItem>(_addCartItemHandler);
    on<PlusOneQuantity>(_plusOneQuantity);
    on<MinusOneQuantity>(_minusOneQuantity);
    on<DeleteCartItem>(_deleteCartItemHandler);
    on<EmptyCart>(_emptyCartHandler);
    on<LoadAICart>(_loadAiCartHandler);
  }

  void loadCartItems() async {
    final items = await _cartLocalStorageRepository.loadCartItems();
    for (var item in items) {
      add(AddCartItem(item));
    }
  }

  void plusOneQuantity(String id) {
    add(PlusOneQuantity(id));
  }

  void minusOneQuantity(String id) {
    add(MinusOneQuantity(id));
  }

  void addCartItem(CartItem item) {
    add(AddCartItem(item));
  }

  void loadAiCart(){
    add(LoadAICart());
  }

  void deleteCartItem(CartItem item) {
    add(DeleteCartItem(item));
  }

  void emptyCart() {
    add(const EmptyCart());
  }

  void _emptyCartHandler(EmptyCart event, Emitter<CartState> emit) {
    _cartLocalStorageRepository.emptyCart();
    emit(state.copyWith(items: []));
  }

  void _addCartItemHandler(AddCartItem event, Emitter<CartState> emit) {
    final newItems = [...state.items];
    if (newItems.any((element) => element.id == event.item.id)) {
      plusOneQuantity(event.item.id);
      return;
    }

    final newCartItem = CartItem(
        id: event.item.id,
        name: event.item.name,
        imgUrl: event.item.imgUrl,
        price: event.item.price,
        presentation: event.item.presentation,
        quantity: event.item.quantity,
        type: event.item.type);

    _cartLocalStorageRepository.addCartItem(newCartItem);
    emit(state.copyWith(items: [...state.items, newCartItem]));
  }

  void _deleteCartItemHandler(DeleteCartItem event, Emitter<CartState> emit) {
    final newItems = [...state.items];
    newItems.removeWhere((item) => item.id == event.item.id);
    _cartLocalStorageRepository.removeCartItem(event.item.id);
    emit(state.copyWith(items: newItems));
  }

  void _plusOneQuantity(PlusOneQuantity event, Emitter<CartState> emit) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(quantity: item.quantity + 1);
      }

      return item;
    }).toList();
    _cartLocalStorageRepository.operateCartItem(event.id, 1);
    emit(state.copyWith(items: newItems));
  }

  void _minusOneQuantity(MinusOneQuantity event, Emitter<CartState> emit) {
    final newItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(
            quantity: item.quantity == 1 ? item.quantity : item.quantity - 1);
      }

      return item;
    }).toList();
    _cartLocalStorageRepository.operateCartItem(event.id, -1);
    emit(state.copyWith(items: newItems));
  }

  void _loadAiCartHandler(LoadAICart event, Emitter<CartState> emit) async {
    final items = await _cartGetAiRepository.loadAICart();
    if (items.isSuccess){
      final cart = items.value;
      for (var item in cart!) {
        add(AddCartItem(item));
      }
    }
  }



}
