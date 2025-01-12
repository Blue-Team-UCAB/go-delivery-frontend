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
  final String type;

  CartItemMapper({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.price, 
    required this.presentation, 
    required this.quantity,
    required this.type
  });

  factory CartItemMapper.fromJsonMap(Map<String, dynamic> json) => CartItemMapper(
      id:json['id'],name: json['name'], imgUrl: json['images'][0], price: json['price'], presentation: json['presentation'],quantity: json['quantity'],type:'product');

  factory CartItemMapper.fromProduct(Product producto) => CartItemMapper(
    id: producto.id, name: producto.name, imgUrl: producto.images.first, price: producto.price, presentation: 'presentation', quantity: 1,type: 'product');

  factory CartItemMapper.fromBundle(Bundle bundle) => CartItemMapper(
    id: bundle.id, name: bundle.name, imgUrl: bundle.images.first, price: bundle.price, presentation: bundle.description, quantity: 1, type: 'bundle');

  factory CartItemMapper.fromIsarCartItem(IsarCartitem isarItem) => CartItemMapper(
    id: isarItem.id, name: isarItem.name, imgUrl: isarItem.imgUrl, price: isarItem.price, presentation: 'presentation', quantity: isarItem.quantity, type: isarItem.type);
  
  factory CartItemMapper.fromCartItem(CartItem item) => CartItemMapper(
    id: item.id, name: item.name, imgUrl: item.imgUrl!, price: item.price, presentation: 'presentation', quantity: item.quantity, type: item.type);
  
  IsarCartitem toIsarCartItemEntity() => IsarCartitem(
    id: id, 
    name: name, 
    imgUrl: imgUrl,
    price: price, 
    presentation: presentation, 
    quantity: quantity,
    type: type);


  CartItem toCartItemEntity() => CartItem(
      id: id,
      name : name,
      imgUrl: imgUrl,
      price: price,
      presentation: presentation,
      quantity: quantity,
      type: type
    );
}
