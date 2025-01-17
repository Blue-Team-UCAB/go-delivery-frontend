import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';

abstract class BundleRepository {
  Future<Result<List<Bundle>>> getBundles({
    List<String>? categories,
    String? name,
    int? price,
    String? popular,
    String? discount,
    required int page,
    required int perpage,
  });

  Future<Result<Bundle>> getBundleById(String bundleId);
}
