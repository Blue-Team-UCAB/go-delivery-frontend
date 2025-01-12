class BundleProduct {
  final String id;
  final String name;
  final double price;
  final double? weight;
  final int? quantity;
  final List<String> images;

  const BundleProduct({
    required this.id,
    required this.name,
    required this.price,
    this.weight,
    this.quantity,
    required this.images,
  });

  BundleProduct copyWith({
    String? id,
    String? name,
    double? price,
    double? weight,
    int? quantity,
    List<String>? images,
  }) {
    return BundleProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
    );
  }
}
