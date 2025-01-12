import 'package:go_delivery_frontend/domain/entities/bundle/bundle.dart';
import 'package:go_delivery_frontend/domain/repositories/bundle/bundle_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/bundle/bundle_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';

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
    String? category,
    String? name,
    String? number,
    String? popular,
    String? discount,
    required int page,
    required int perpage,
  }) async {
    await _addAuthorizationHeader();

    print("______ BUNDLE MANY ______");

      final response = await _apiRequestManager.request(
        '/api/bundle/many',
        'GET',
        queryParameters: {
          'page': page.toString(),
          'perpage': perpage.toString(),
        },
        (data) {
          List<Bundle> bundles = (data as List)
              .map((bundleData) => BundleMapper.fromJson(bundleData))
              .toList();
          return bundles;
        },
      );
      return response;
  }

  @override
  Future<Result<Bundle>> getBundleById(String bundleId) async {
    print("______ BUNDLE BY ID ______");

    await _addAuthorizationHeader();

      final response = await _apiRequestManager.request(
        '/api/bundle/$bundleId',
        'GET',
        (data) {
          // Imprimir los datos recibidos de la API
          print('Respuesta de la API para el bundle: $data');

          final bundle = BundleMapper.fromJson(data);


          return bundle;
        },
      );
      return response;
  }
}
