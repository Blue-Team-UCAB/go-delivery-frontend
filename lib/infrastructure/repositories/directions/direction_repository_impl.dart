import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/application/use_cases/direction/add/add_direction.dart';
import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/repositories/direction/direction_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/direction/direction_mapper.dart';

class DirectionRepositoryImpl extends DirectionRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  DirectionRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<Direction>>> getDirections() async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/api/user/address/many',
        'GET',
        (data) => DirectionMapper.fromJsonList(data['value']),
      );

      if (response.isSuccessful()) {
        final directions = response.getValue();
        return Result.success(directions);
      } else {
        final error = response.getError();
        return Result.fail(
            ServerFailure(message: 'Error al obtener direcciones: $error'));
      }
    } catch (e) {
      print('Error in DirectionRepositoryImpl.getDirections: $e');
      return Result.fail(
          ServerFailure(message: 'Failed to fetch directions: $e'));
    }
  }

  @override
  Future<Result<void>> addDirection(AddDirectionInput input) async {
    await _addAuthorizationHeader();

    try {
      final response = await _apiRequestManager.request(
        '/api/user/add/address',
        'POST',
        (data) => null,
        body: DirectionMapper.toJsonAdd(input),
      );

      if (response.isSuccessful()) {
        return Result.success(null);
      } else {
        final error = response.getError();
        return Result.fail(
            ServerFailure(message: 'Error al agregar dirección: $error'));
      }
    } catch (e) {
      print('Error in DirectionRepositoryImpl.addDirection: $e');
      return Result.fail(ServerFailure(message: 'Failed to add direction: $e'));
    }
  }
}
