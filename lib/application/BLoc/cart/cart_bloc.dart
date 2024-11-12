import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(
    items: [
    CartItem(id:'1' ,name: 'Dorito', imgUrl: 'imgUrl', price: 2.30, presentation: '150 gr',quantity: 1),
    CartItem(id:'2' ,name: 'Seven Up', imgUrl: 'imgUrl', price: 1.20, presentation: '1.5 Lt',quantity: 1),
    CartItem(id:'3' ,name: 'Pepito', imgUrl: 'imgUrl', price: 1.30, presentation: '150 gr',quantity: 1),
    CartItem(id:'4' ,name: 'Coca-Cola', imgUrl: 'imgUrl', price: 1.00, presentation: '1.5 Lt',quantity: 1),
    CartItem(id:'5' ,name: 'Yuka-Chips', imgUrl: 'imgUrl', price: 3.30, presentation: '150 gr',quantity: 1),
    CartItem(id:'6' ,name: 'Redbull', imgUrl: 'imgUrl', price: 0.70, presentation: '0.5 Lt',quantity: 1),
    CartItem(id:'7' ,name: 'Pepsi', imgUrl: 'imgUrl', price: 1.00, presentation: '1.5 Lt',quantity: 1),
    CartItem(id:'8' ,name: 'Simply Jalapeño', imgUrl: 'imgUrl', price: 3.00, presentation: '150 gr',quantity: 1),
    CartItem(id:'9' ,name: 'Monster Original', imgUrl: 'imgUrl', price: 0.80, presentation: '0.5 Lt',quantity: 1),
  ]
  )) {

    on<AddCartItem>(_addCartItemHandler);
    on<PlusOneQuantity>(_plusOneQuantity);
    on<MinusOneQuantity>(_minusOneQuantity);
    on<DeleteCartItem>(_deleteCartItemHandler);
    
  }

  void plusOneQuantity(String id){
    add(PlusOneQuantity(id));
  }
  void minusOneQuantity(String id){
    add(MinusOneQuantity(id));
  }

  void addCartItem(CartItem item) {
    add(AddCartItem(item));
  }
  void deleteCartItem(CartItem item) {
    add(DeleteCartItem(item));
  }

  void _addCartItemHandler(AddCartItem event, Emitter<CartState> emit){

    final newItems = [...state.items];
    if (newItems.any((element) => element.id == event.item.id)) {
      plusOneQuantity(event.item.id);
      return;
    }

    final newCartItem = CartItem(
      id: event.item.id,
      name: event.item.name , 
      imgUrl: event.item.imgUrl, 
      price: event.item.price, 
      presentation: event.item.presentation, 
      quantity: event.item.quantity
    );

    emit(state.copyWith(items: [...state.items, newCartItem]));
  }

  void _deleteCartItemHandler(DeleteCartItem event, Emitter<CartState> emit){
    final newItems = [...state.items];
    newItems.removeWhere((item)=> item.id == event.item.id);
    emit(state.copyWith(items: newItems));
  }

  void _plusOneQuantity(PlusOneQuantity event, Emitter<CartState> emit){
    final newItems = state.items.map((item) {

        if (item.id == event.id) {
          return item.copyWith(
            quantity: item.quantity + 1
          );
        } 
        
        return item;
        
      }).toList();
  
      emit(state.copyWith(items: newItems));

  }

  void _minusOneQuantity(MinusOneQuantity event, Emitter<CartState> emit){
    final newItems = state.items.map((item) {

        if (item.id == event.id) {
          return item.copyWith(
            quantity: item.quantity == 1 ? item.quantity : item.quantity - 1
          );
        } 
        
        return item;
        
      }).toList();
  
      emit(state.copyWith(items: newItems));

  }

}