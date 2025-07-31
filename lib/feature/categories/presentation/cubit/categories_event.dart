import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class GetCategories extends CategoriesEvent {}

class GetProductsByCategory extends CategoriesEvent {
  final String category;

  const GetProductsByCategory({required this.category});

  @override
  List<Object?> get props => [category];
} 