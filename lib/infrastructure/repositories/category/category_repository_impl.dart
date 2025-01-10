import 'package:go_delivery_frontend/common/failure.dart';
import 'package:go_delivery_frontend/domain/repositories/category/category_repository.dart';
import 'package:go_delivery_frontend/infrastructure/mappers/category/category_mapper.dart';
import 'package:go_delivery_frontend/application/key_value_storage/key_value.dart';
import 'package:go_delivery_frontend/common/result.dart';

import '../../../application/api/api_request.dart';
import '../../../domain/entities/category/category.dart';

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
    String? search,
    String? category,
    required int page,
    required int perpage,
  }) async {
    await _addAuthorizationHeader();

    try {
      Map<String, String> queryParameters = {
        'page': page.toString(),
        'perpage': perpage.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      if (category?.isNotEmpty ?? false) {
        queryParameters['category'] = category!;
      }

      final response = await _apiRequestManager.request(
        '/api/category',
        'GET',
        queryParameters: queryParameters,
        (data) {
          List<Category> categories = (data['category'] as List)
              .map((categoryData) => CategoryMapper.fromJson(categoryData))
              .toList();
          return categories;
        },
      );
      return response;
    } catch (e) {
      print('Error in CategoryRepositoryImpl.getCategories: $e');
      return Result.fail(Exception('Failed to fetch categores: $e') as Failure);
    }
  }
}
