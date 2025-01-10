import 'package:go_delivery_frontend/common/result.dart';
import 'package:go_delivery_frontend/common/use_cases.dart';
import 'package:go_delivery_frontend/domain/entities/category/category.dart';
import 'package:go_delivery_frontend/domain/repositories/category/category_repository.dart';

// get_categories_use_case.dart
class GetCategoriesInput extends IUseCaseInput {
  final String? search;
  final String? category;
  final int page;
  final int perpage;

  GetCategoriesInput({
    this.search,
    this.category,
    required this.page,
    required this.perpage,
  });
}

class GetCategoriesUseCase
    implements IUseCase<GetCategoriesInput, List<Category>> {
  final CategoryRepository _categoryRepository;

  GetCategoriesUseCase({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  @override
  Future<Result<List<Category>>> execute(GetCategoriesInput input) async {
    return await _categoryRepository.getCategories(
      search: input.search ?? '',
      category: input.category,
      page: input.page,
      perpage: input.perpage,
    );
  }
}
