import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/direction/direction_repository.dart';

class AddDirectionInput extends IUseCaseInput {
  final String name;
  final String direction;
  final double lat;
  final double long;
  final bool favorite;

  AddDirectionInput(
      {required this.name,
      required this.direction,
      required this.lat,
      required this.long,
      required this.favorite});
}

class AddDirectionUseCase implements IUseCase<AddDirectionInput, void> {
  final DirectionRepository _directionRepository;

  AddDirectionUseCase({required DirectionRepository directionRepository})
      : _directionRepository = directionRepository;

  @override
  Future<Result<void>> execute(AddDirectionInput input) async {
    try {
      await _directionRepository.addDirection(input);
      return Result.success(null);
    } catch (e) {
      return Result.fail(
          ServerFailure(message: "Error al agregar dirección: $e"));
    }
  }
}
