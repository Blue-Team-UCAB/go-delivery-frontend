import '../../../common/result.dart';

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
}
