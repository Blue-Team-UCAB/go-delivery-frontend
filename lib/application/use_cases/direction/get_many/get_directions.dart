import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/direction/direction.dart';
import 'package:go_delivery_frontend/domain/repositories/direction/direction_repository.dart';

class GetDirectionsUseCaseInput extends IUseCaseInput {
  GetDirectionsUseCaseInput();
}

class GetDirectionsUseCase {
  final DirectionRepository _directionRepository;

  GetDirectionsUseCase({required DirectionRepository directionRepository})
      : _directionRepository = directionRepository;

  Future<Result<List<Direction>>> execute(GetDirectionsUseCaseInput input) {
    return _directionRepository.getDirections();
  }
}
