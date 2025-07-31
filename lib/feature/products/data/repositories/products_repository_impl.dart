import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../datasources/products_remote_data_source.dart';
import '../models/products_response_model.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductsResponseModel> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    return await remoteDataSource.getProductById(productId);
  }
} 