import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/repositories/bundle/bundle_repository.dart';

class GetBundlesUseCaseInput extends IUseCaseInput {
  final int page;
  final int perpage;
  final List<String>? categories;
  final String? name;
  final int? price;
  final String? popular;
  final String? discount;

  GetBundlesUseCaseInput({
    required this.page,
    required this.perpage,
    this.categories,
    this.name,
    this.price,
    this.popular,
    this.discount,
  });
}

class GetBundlesUseCase {
  final BundleRepository _bundleRepository;

  GetBundlesUseCase({required BundleRepository bundleRepository})
      : _bundleRepository = bundleRepository;

  Future<Result<List<Bundle>>> execute(GetBundlesUseCaseInput input) {
    return _bundleRepository.getBundles(
      page: input.page,
      perpage: input.perpage,
      categories: input.categories!,
      name: input.name!,
      price: input.price!,
      popular: input.popular!,
      discount: input.discount!,
    );
  }
}
