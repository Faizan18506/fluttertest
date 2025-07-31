import '../../data/models/products_response_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductsRepository {
  Future<ProductsResponseModel> getProducts();
  Future<ProductModel> getProductById(int productId);
} 