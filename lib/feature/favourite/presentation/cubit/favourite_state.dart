import 'package:equatable/equatable.dart';
import '../../../products/data/models/product_model.dart';

abstract class FavouriteState extends Equatable {
  const FavouriteState();
  @override
  List<Object> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoaded extends FavouriteState {
  final List<ProductModel> favourites;
  const FavouriteLoaded(this.favourites);
  @override
  List<Object> get props => [favourites];
} 