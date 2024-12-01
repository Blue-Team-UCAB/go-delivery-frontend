import 'package:isar/isar.dart';

part 'isar_cartitem.g.dart';

@collection
class IsarCartitem {

  Id? isarId;

  final String id;
  final String name;
  final String imgUrl;
  final double price;
  final String presentation;
  final int quantity;

  IsarCartitem({
    required this.id,
    required this.name, 
    required this.imgUrl, 
    required this.price, 
    required this.presentation,
    required this.quantity,
  });

  IsarCartitem copyWith({
    String? id,
    String? name,
    String? imgUrl,
    double? price,
    String? presentation,
    int? quantity,
  }) => IsarCartitem(
    id: id ?? this.id, 
    name: name ?? this.name, 
    imgUrl: imgUrl ?? this.imgUrl, 
    price: price ?? this.price, 
    presentation: presentation ?? this.presentation, 
    quantity: quantity ?? this.quantity);
}