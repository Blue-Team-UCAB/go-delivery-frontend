import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/repositories/bundle/bundle_repository.dart';

//Añadiendo un comentario para poder hacer commit
class GetOneBundleUseCaseInput extends IUseCaseInput {
  final String bundleId;

  GetOneBundleUseCaseInput({required this.bundleId});
}

class GetOneBundleUseCase {
  final BundleRepository _bundleRepository;

  GetOneBundleUseCase({required BundleRepository bundleRepository})
      : _bundleRepository = bundleRepository;

  Future<Result<Bundle>> execute(GetOneBundleUseCaseInput input) {
    return _bundleRepository.getBundleById(input.bundleId);
  }
}
