import 'package:go_delivery_frontend/application/use_cases/direction/add/add_direction.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/patch/patch_direction.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';

abstract class DirectionRepository {
  Future<Result<List<Direction>>> getDirections();
  Future<Result<dynamic>> addDirection(AddDirectionInput input);
  Future<Result<Direction>> updateDirection(UpdateDirectionInput input);
  Future<Result<dynamic>> deleteAddress(String addressId);
}
