enum UserType { CLIENT, ADMIN }

class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String image;
  final UserType type;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.image,
    required this.type,
    required this.token,
  });

  static String userTypeToString(UserType type) {
    switch (type) {
      case UserType.CLIENT:
        return 'CLIENT';
      case UserType.ADMIN:
        return 'ADMIN';
    }
  }
}