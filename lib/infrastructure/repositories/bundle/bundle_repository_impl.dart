import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/repositories/bundle/bundle_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/bundle/bundle_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import '../../../application/api/api_request.dart';

class BundleRepositoryImpl extends BundleRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  BundleRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<Bundle>>> getBundles({
    required int page,
    required int take,
  }) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/bundle',
        'GET',
        queryParameters: {
          'page': page.toString(),
          'take': take.toString(),
        },
        (data) {
          List<Bundle> bundles = (data['bundles'] as List)
              .map((bundleData) => BundleMapper.fromJson(bundleData))
              .toList();
          return bundles;
        },
      );
      return response;
    } catch (e) {
      print('Error in BundleRepositoryImpl.getBundles: $e');
      rethrow;
    }
  }

  @override
  Future<Result<Bundle>> getBundleById(String bundleId) async {
    await _addAuthorizationHeader();
    try {
      final response = await _apiRequestManager.request(
        '/bundle/$bundleId',
        'GET',
        (data) {
          final bundle = BundleMapper.fromJson(data);
          return bundle;
        },
      );
      return response;
    } catch (e) {
      print('Error in BundleRepositoryImpl.getBundleById: $e');
      rethrow;
    }
  }
}
