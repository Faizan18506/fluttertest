import 'package:equatable/equatable.dart';
import '../../data/models/products_response_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final ProductsResponseModel productsResponse;

  const ProductsLoaded({required this.productsResponse});

  @override
  List<Object> get props => [productsResponse];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

// Product Details States
class ProductDetailsLoading extends ProductsState {}

class ProductDetailsLoaded extends ProductsState {
  final ProductModel product;

  const ProductDetailsLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductDetailsError extends ProductsState {
  final String message;

  const ProductDetailsError({required this.message});

  @override
  List<Object> get props => [message];
} 