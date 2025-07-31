import '../repositories/products_repository.dart';
import '../../data/models/product_model.dart';

class GetProductByIdUseCase {
  final ProductsRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<ProductModel> call(int productId) async {
    return await repository.getProductById(productId);
  }
} 