import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/repositories/direction/direction_repository.dart';

class UpdateDirectionInput extends IUseCaseInput {
  final String directionId;
  final String name;
  final String direction;
  final double lat;
  final double long;
  final bool favorite;

  UpdateDirectionInput({
    required this.directionId,
    required this.name,
    required this.direction,
    required this.lat,
    required this.long,
    required this.favorite,
  });
}

class UpdateDirectionUseCase
    implements IUseCase<UpdateDirectionInput, Direction> {
  final DirectionRepository _directionRepository;

  UpdateDirectionUseCase({required DirectionRepository directionRepository})
      : _directionRepository = directionRepository;

  @override
  Future<Result<Direction>> execute(UpdateDirectionInput input) async {
    try {
      final result = await _directionRepository.updateDirection(input);
      return result;
    } catch (e) {
      return Result.fail(
          ServerFailure(message: "Error al actualizar la dirección: $e"));
    }
  }
}
