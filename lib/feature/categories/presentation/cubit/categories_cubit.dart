import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_by_category_usecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  CategoriesCubit({
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(CategoriesInitial());

  Future<void> getCategories() async {
    print('CategoriesCubit: getCategories called');
    emit(CategoriesLoading());
    try {
      final categoriesResponse = await getCategoriesUseCase();
      print('CategoriesCubit: Categories loaded');
      emit(CategoriesLoaded(categoriesResponse: categoriesResponse));
    } catch (e) {
      print('CategoriesCubit: Error in getCategories: ' + e.toString());
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> getProductsByCategory(String category) async {
    print('CategoriesCubit: getProductsByCategory called for $category');
    emit(ProductsByCategoryLoading());
    try {
      final productsResponse = await getProductsByCategoryUseCase(category);
      print('CategoriesCubit: Products by category loaded');
      emit(ProductsByCategoryLoaded(productsResponse: productsResponse));
    } catch (e) {
      print('CategoriesCubit: Error in getProductsByCategory: ' + e.toString());
      emit(ProductsByCategoryError(message: e.toString()));
    }
  }
} 