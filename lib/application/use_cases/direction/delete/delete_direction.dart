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
  Future<Result<void>> execute(DeleteAddressUseCaseInput input) {
    return _directionRepository.deleteAddress(input.addressId);
  }
}
