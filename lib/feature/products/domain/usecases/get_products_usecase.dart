import '../../data/models/products_response_model.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase({required this.repository});

  Future<ProductsResponseModel> call() async {
    return await repository.getProducts();
  }
} 