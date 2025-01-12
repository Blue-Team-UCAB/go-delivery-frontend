import 'dart:io';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/infrastructure/models/user_model.dart';

abstract class UserRepository {
  Future<Result<bool>> register(
      {required String email,
      required String password,
      required String name,
      required String phone});
  Future<Result<bool>> login(String email, String password);
  Future<Result<bool>> sendRecoveryCode(String email);
  Future<Result<bool>> validateRecoveryCode(String email, String code);
  Future<Result<bool>> changePassword(
      String email, String code, String password);
  Future<Result<User>> getCurrent();
  Future<Result<bool>> updateUserImage(File image);
}
