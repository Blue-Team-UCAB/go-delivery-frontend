import 'package:go_delivery_frontend/infrastructure/models/user_model.dart';

class UserMapper {
  static User fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      image: json['image'] as String? ?? '',
      type: _parseUserType(json['type'] as String? ?? ''),
      token: token ?? json['token'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'phone': user.phone,
      'image': user.image,
      'type': _userTypeToString(user.type),
      'token': user.token,
    };
  }

  static UserType _parseUserType(String type) {
    switch (type.toUpperCase()) {
      case 'CLIENT':
        return UserType.CLIENT;
      case 'ADMIN':
        return UserType.ADMIN;
      default:
        return UserType.CLIENT; // Default to CLIENT if type is unknown
    }
  }

  static String _userTypeToString(UserType type) {
    switch (type) {
      case UserType.CLIENT:
        return 'CLIENT';
      case UserType.ADMIN:
        return 'ADMIN';
    }
  }
}
