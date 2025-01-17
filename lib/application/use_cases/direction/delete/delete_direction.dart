import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/repositories/direction/direction_repository.dart';

class DeleteAddressUseCaseInput extends IUseCaseInput {
  final String addressId;

  DeleteAddressUseCaseInput({required this.addressId});
}

class DeleteAddressUseCase
    implements IUseCase<DeleteAddressUseCaseInput, void> {
  final DirectionRepository _directionRepository;

  DeleteAddressUseCase({required DirectionRepository directionRepository})
      : _directionRepository = directionRepository;

  @override
  Future<Result<dynamic>> execute(DeleteAddressUseCaseInput input) async {
    final result = await _directionRepository.deleteAddress(input.addressId);

    if (result.value == null && result.error == null) {
      return Result.fail(ServerFailure(message: 'Error inesperado.'));
    }
    return result;
  }
}
