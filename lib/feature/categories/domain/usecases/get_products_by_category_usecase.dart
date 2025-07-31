import '../../../products/data/models/products_response_model.dart';

import '../repositories/categories_repository.dart';

class GetProductsByCategoryUseCase {
  final CategoriesRepository repository;

  GetProductsByCategoryUseCase({required this.repository});

  Future<ProductsResponseModel> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
} 