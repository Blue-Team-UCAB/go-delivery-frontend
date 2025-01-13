import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/repositories/category/category_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/category/category_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import 'package:go_delivery_frontend/application/api/api_request.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final IApiRequestManager _apiRequestManager;
  final LocalStorage _localStorage;

  CategoryRepositoryImpl({
    required IApiRequestManager apiRequestManager,
    required LocalStorage localStorage,
  })  : _apiRequestManager = apiRequestManager,
        _localStorage = localStorage;

  Future<void> _addAuthorizationHeader() async {
    final token = await _localStorage.getAuthorizationToken();
    _apiRequestManager.setHeaders('Authorization', 'Bearer $token');
  }

  @override
  Future<Result<List<Category>>> getCategories({
    String? name,
    required int page,
    required int perpage,
  }) async {
    await _addAuthorizationHeader();

    try {
      Map<String, String> queryParameters = {
        'page': page.toString(),
        'perpage': perpage.toString(),
      };

      if (name != null && name.isNotEmpty) {
        queryParameters['name'] = name;
      }

      final response = await _apiRequestManager.request(
        '/api/category/many',
        'GET',
        queryParameters: queryParameters,
        (data) {
          if (data is Map<String, dynamic> && data.containsKey('categories')) {
            final categoriesData = data['categories'];
            if (categoriesData is List) {
              return categoriesData
                  .map((categoryData) => CategoryMapper.fromJson(categoryData))
                  .toList();
            }
          }
          return <Category>[];
        },
      );
      return response;
    } catch (e) {
      return Result.fail('Error loading categories: $e' as Failure);
    }
  }
}
