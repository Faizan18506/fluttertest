import '../../data/models/categories_response_model.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<CategoriesResponseModel> call() async {
    return await repository.getCategories();
  }
} 