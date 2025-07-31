import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/products_response_model.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductsCubit({
    required this.getProductsUseCase,
    required this.getProductByIdUseCase,
  }) : super(ProductsInitial());

  Future<void> getProducts() async {
    print('ProductsCubit: getProducts() called');
    emit(ProductsLoading());
    print('ProductsCubit: Emitted ProductsLoading');
    try {
      final productsResponse = await getProductsUseCase();
      emit(ProductsLoaded(productsResponse: productsResponse));
      print('ProductsCubit: Emitted ProductsLoaded with ${productsResponse.products.length} products');
    } catch (e) {
      emit(ProductsError(message: e.toString()));
      print('ProductsCubit: Emitted ProductsError: ${e.toString()}');
    }
  }

  Future<void> getProductById(int productId) async {
    print('ProductsCubit: getProductById($productId) called');
    // Store the current state before emitting ProductDetailsLoading
    final currentState = state;
    emit(ProductDetailsLoading());
    print('ProductsCubit: Emitted ProductDetailsLoading');
    try {
      final product = await getProductByIdUseCase(productId);
      emit(ProductDetailsLoaded(product: product));
      print('ProductsCubit: Emitted ProductDetailsLoaded for product ${product.id}');
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
      print('ProductsCubit: Emitted ProductDetailsError: ${e.toString()}');
    }
  }

  // Method to restore products state after returning from product details
  void restoreProductsState(ProductsResponseModel productsResponse) {
    print('ProductsCubit: restoreProductsState() called');
    emit(ProductsLoaded(productsResponse: productsResponse));
    print('ProductsCubit: Restored ProductsLoaded state');
  }
} 