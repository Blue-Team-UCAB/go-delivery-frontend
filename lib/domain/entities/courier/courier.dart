class Courier {
  final String courierName;
  final String phone;
  final String courierImage;

  Courier({
    required this.courierName,
    required this.phone,
    required this.courierImage,
  });

  // Optional: Add equality and hashCode for comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Courier &&
              courierName == other.courierName &&
              phone == other.phone &&
              courierImage == other.courierImage;

  @override
  int get hashCode =>
      courierName.hashCode ^ phone.hashCode ^ courierImage.hashCode;
}