import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String name;
  final String imgUrl;
  final double price;
  final String presentation;
  final int quantity;
  final String type;

  const CartItem({
    required this.id,
    required this.name, 
    required this.imgUrl, 
    required this.price, 
    required this.presentation,
    required this.quantity,
    required this.type
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? imgUrl,
    double? price,
    String? presentation,
    int? quantity,
    String? type
  }) => CartItem(
    id: id ?? this.id, 
    name: name ?? this.name, 
    imgUrl: imgUrl ?? this.imgUrl, 
    price: price ?? this.price, 
    presentation: presentation ?? this.presentation, 
    quantity: quantity ?? this.quantity,
    type : type ?? this.type
  );

  @override
  List<Object> get props => [quantity];
}