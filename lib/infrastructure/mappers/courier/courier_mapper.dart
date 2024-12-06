import '../../../domain/entities/courier/courier.dart';

class CourierMapper {
  static Courier fromJson(Map<String, dynamic> json) {
    return Courier(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Driver',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toJson(Courier courier) {
    return {
      'id': courier.id,
      'name': courier.name,
      'phoneNumber': courier.phoneNumber,
    };
  }

  // Optional: Method to handle nullable or partial data
  static Courier? fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    if (json['id'] == null || json['name'] == null || json['phoneNumber'] == null) {
      return null;
    }

    return fromJson(json);
  }

  // Optional: Conversion from other data sources
  static Courier fromDriverDetails(dynamic driverDetails) {
    if (driverDetails is Map<String, dynamic>) {
      return fromJson(driverDetails);
    }

    // Add more conversion logic as needed
    throw ArgumentError('Unsupported driver details type');
  }
}