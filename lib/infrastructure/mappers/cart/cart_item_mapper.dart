import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/entities/cart/cartitem.dart';
import 'package:go_delivery_frontend/domain/entities/product/product.dart';
import 'package:go_delivery_frontend/infrastructure/entities/cart/isar_cartitem.dart';


class CartItemMapper {
  final String id;
  final String name;
  final String imgUrl;
  final double price;
  final String presentation;
  final int quantity;

  CartItemMapper({
    required this.id,
    required this.name,
    required this.imgUrl, 
    required this.price, 
    required this.presentation, 
    required this.quantity
  });

  factory CartItemMapper.fromJsonMap(Map<String, dynamic> json) => CartItemMapper(
      id:json['id'],name: json['name'], imgUrl: json['imgUrl'], price: json['price'], presentation: json['presentation'],quantity: json['quantity']);

  factory CartItemMapper.fromProduct(Product producto) => CartItemMapper(
    id: producto.id, name: producto.name, imgUrl: producto.imageUrl, price: producto.price, presentation: 'presentation', quantity: 1);

  factory CartItemMapper.fromBundle(Bundle bundle) => CartItemMapper(
    id: bundle.id, name: bundle.name, imgUrl: bundle.imageUrl, price: bundle.price, presentation: bundle.description, quantity: 1);

  factory CartItemMapper.fromIsarCartItem(IsarCartitem isarItem) => CartItemMapper(
    id: isarItem.id, name: isarItem.name, imgUrl: isarItem.imgUrl, price: isarItem.price, presentation: 'presentation', quantity: isarItem.quantity);
  
  factory CartItemMapper.fromCartItem(CartItem item) => CartItemMapper(
    id: item.id, name: item.name, imgUrl: item.imgUrl, price: item.price, presentation: 'presentation', quantity: item.quantity);
  
  IsarCartitem toIsarCartItemEntity() => IsarCartitem(
    id: id, 
    name: name, 
    imgUrl: imgUrl, 
    price: price, 
    presentation: presentation, 
    quantity: quantity);


  CartItem toCartItemEntity() => CartItem(
      id: id,
      name : name,
      imgUrl: imgUrl,
      price: price,
      presentation: presentation,
      quantity: quantity
    );
}
