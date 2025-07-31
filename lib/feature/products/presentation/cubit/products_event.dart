import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class GetProducts extends ProductsEvent {}

class GetProductById extends ProductsEvent {
  final int productId;

  const GetProductById(this.productId);

  @override
  List<Object> get props => [productId];
} 