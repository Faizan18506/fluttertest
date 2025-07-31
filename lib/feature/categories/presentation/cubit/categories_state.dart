import 'package:equatable/equatable.dart';
import '../../data/models/categories_response_model.dart';
import '../../../../feature/products/data/models/products_response_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final CategoriesResponseModel categoriesResponse;

  const CategoriesLoaded({required this.categoriesResponse});

  @override
  List<Object?> get props => [categoriesResponse];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Products by Category States
class ProductsByCategoryLoading extends CategoriesState {}

class ProductsByCategoryLoaded extends CategoriesState {
  final ProductsResponseModel productsResponse;

  const ProductsByCategoryLoaded({required this.productsResponse});

  @override
  List<Object?> get props => [productsResponse];
}

class ProductsByCategoryError extends CategoriesState {
  final String message;

  const ProductsByCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
} 