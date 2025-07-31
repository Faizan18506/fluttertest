import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'feature/products/data/datasources/products_remote_data_source.dart';
import 'feature/products/data/repositories/products_repository_impl.dart';
import 'feature/products/domain/repositories/products_repository.dart';
import 'feature/products/domain/usecases/get_products_usecase.dart';
import 'feature/products/domain/usecases/get_product_by_id_usecase.dart';
import 'feature/products/presentation/cubit/products_cubit.dart';
import 'feature/categories/data/datasources/categories_remote_data_source.dart';
import 'feature/categories/data/repositories/categories_repository_impl.dart';
import 'feature/categories/domain/repositories/categories_repository.dart';
import 'feature/categories/domain/usecases/get_categories_usecase.dart';
import 'feature/categories/domain/usecases/get_products_by_category_usecase.dart';
import 'feature/categories/presentation/cubit/categories_cubit.dart';
import 'feature/favourite/presentation/cubit/favourite_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Products
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(repository: sl()),
  );
  sl.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getProductsUseCase: sl(),
      getProductByIdUseCase: sl(),
    ),
  );

  // Categories
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(repository: sl()),
  );
  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      getCategoriesUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
    ),
  );

  // Favourites
  sl.registerSingleton<FavouriteCubit>(FavouriteCubit());
} 