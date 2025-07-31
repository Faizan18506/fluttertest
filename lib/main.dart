import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertest/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'feature/categories/presentation/cubit/categories_cubit.dart';
import 'feature/favourite/presentation/cubit/favourite_cubit.dart';
import 'feature/products/presentation/cubit/products_cubit.dart';
import 'injection_container.dart';

import 'feature/products/presentation/screens/products_screen.dart';
import 'feature/categories/presentation/screens/categories_screen.dart';
import 'feature/favourite/presentation/screens/favourites_screen.dart';
import 'feature/profile/presentation/screens/profile_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ProductsCubit>()),
            BlocProvider(create: (_) => sl<CategoriesCubit>()),
            BlocProvider(create: (_) => sl<FavouriteCubit>()),
          ],
          child: MaterialApp(
            title: 'Flutter App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

