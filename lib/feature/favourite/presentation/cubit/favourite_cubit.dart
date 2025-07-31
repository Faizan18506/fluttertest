import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/data/models/product_model.dart';
import 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());

  final List<ProductModel> _favourites = [];

  void addToFavourites(ProductModel product) {
    if (!_favourites.any((p) => p.id == product.id)) {
      _favourites.add(product);
      emit(FavouriteLoaded(List.from(_favourites)));
    }
  }

  void removeFromFavourites(ProductModel product) {
    _favourites.removeWhere((p) => p.id == product.id);
    emit(FavouriteLoaded(List.from(_favourites)));
  }

  bool isFavourite(int productId) {
    return _favourites.any((p) => p.id == productId);
  }

  void loadFavourites() {
    emit(FavouriteLoaded(List.from(_favourites)));
  }
} 