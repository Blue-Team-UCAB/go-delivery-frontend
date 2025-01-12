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
    List<String>? categories,
    String? name,
    int? price,
    String? popular,
    String? discount,
    required int page,
    required int perpage,
  }) async {
    await _addAuthorizationHeader();

    print("______ BUNDLE MANY ______");

    final Map<String, dynamic> queryParameters = {
      'page': page.toString(),
      'perpage': perpage.toString(),
    };

    if (name != null && name.trim().isNotEmpty) {
      queryParameters['name'] = name.trim();
    }

    if (categories != null &&
        categories.isNotEmpty &&
        categories.any((category) => category.trim().isNotEmpty)) {
      queryParameters['category'] =
          categories.where((category) => category.trim().isNotEmpty).join(',');
    }

    if (price != null && price > 0) {
      queryParameters['price'] = price;
    }

    if (discount != null && discount.isNotEmpty) {
      queryParameters['discount'] = discount;
    }

    if (popular != null && popular.isNotEmpty) {
      queryParameters['popular'] = popular;
    }

    print('Query Parameters:');
    queryParameters.forEach((key, value) {
      print('  - $key: $value');
    });

    final response = await _apiRequestManager.request(
      '/api/bundle/many',
      'GET',
      queryParameters: queryParameters,
      (dynamic data) {
        if (data is Map<String, dynamic> && data.containsKey('bundles')) {
          List<dynamic> bundlesData = data['bundles'];

          List<Bundle> bundles = bundlesData
              .map((bundleData) {
                try {
                  return BundleMapper.fromJson(bundleData);
                } catch (e) {
                  print('Error parsing individual bundle: $e');
                  return null;
                }
              })
              .whereType<Bundle>()
              .toList();

          return bundles;
        } else if (data is List) {
          List<Bundle> bundles = data
              .map((bundleData) {
                try {
                  return BundleMapper.fromJson(bundleData);
                } catch (e) {
                  print('Error parsing individual bundle: $e');
                  return null;
                }
              })
              .whereType<Bundle>()
              .toList();

          return bundles;
        } else {
          print('Unexpected data format: ${data.runtimeType}');
          print("ERROR AL CARGAR BUNDLES MANY");

          return <Bundle>[];
        }
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
