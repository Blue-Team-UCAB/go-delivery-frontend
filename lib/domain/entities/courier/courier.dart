class Courier {
  final String id;
  final String name;
  final String phone;

  const Courier({
    required this.id,
    required this.name,
    required this.phone,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Courier &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}