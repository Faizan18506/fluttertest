import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_data_source.dart';
import '../models/categories_response_model.dart';
import '../../../../feature/products/data/models/products_response_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CategoriesResponseModel> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<ProductsResponseModel> getProductsByCategory(String category) async {
    try {
      return await remoteDataSource.getProductsByCategory(category);
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }
} 