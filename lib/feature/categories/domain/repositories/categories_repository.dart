import '../../data/models/categories_response_model.dart';
import '../../../../feature/products/data/models/products_response_model.dart';

abstract class CategoriesRepository {
  Future<CategoriesResponseModel> getCategories();
  Future<ProductsResponseModel> getProductsByCategory(String category);
} 