import '../../../domain/entities/client/client.dart';

class ClientMapper {
  static Client fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      avatarImage: json['avatarImage'] as String?,
    );
  }

  static Map<String, dynamic> toJson(Client client) {
    return {
      'id': client.id,
      'name': client.name,
      'phone': client.phone,
      'email': client.email,
      'avatarImage': client.avatarImage,
    };
  }
}