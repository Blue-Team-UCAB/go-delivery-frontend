import '../../models/user_model.dart';

class UserMapper {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'token': user.token,
    };
  }
}